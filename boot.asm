;********************;
; POPCORN BOOTLOADER ;
;********************;

org 0x7c00              ; The BIOS loads the boot sector at 0x7c00

bits 16                 ; The bootloader begins in 16 bit real mode


start:
    jmp main

;***********GLOBAL DESCRIPTOR TABLE********;
gdt_start:
    dq 0x0          ; null descriptor (8 zeroed bytes)
gdt_code:
    dw 0xFFFF       ; limit low
    dw 0x0          ; base low
    db 0x0          ; base middle
    db 10011010b    ; access byte
    db 11001111b    ; granularity byte
    db 0x0          ; base high
gdt_data:
    dw 0xFFFF       ; limit low
    dw 0x0          ; base low
    db 0x0          ; base middle
    db 10010010b    ; access
    db 11001111b    ; granularity
    db 0x0          ;base high
gdt_end:

gdt_pointer:
    dw gdt_end - gdt_start
    dd gdt_start
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
;******************************************;


msg:                db "Boot sector:  Executing Stage 1...", 13, 10, 0
disk_error_msg:     db "Disk read error", 0
sectors_error_msg:  db "Incorrect number of sectors read", 0
jumping_msg:        db "Boot sector:  Loaded new sector(s) into memory.", 13, 10, "Jumping to kernel entrypoint...", 13, 10, 0
disk: db 0x00


;Print routine
print:
    lodsb               ; Load next byte in string
    or al, al           ; If byte is 0, return, else print character.
    jz print_done
    mov ah, 0x0e
    int 0x10
    jmp print
print_done:
    ret
    
    
disk_error:
    mov si, disk_error_msg
    call print
    jmp $


sectors_error:
    mov si, sectors_error_msg
    call print
    jmp $


main:

    mov ax, 0x2401      ; Activate A20 line
	int 0x15
	
    mov ax, 0x3         ; Set VGA mode to safe value (text mode 3)
	int 0x10
    
    mov bp, 0x8000      ; Move the stack far away
    mov sp, bp
    
    ;Print loading message
    mov si, msg         ; Print message string at msg
    call print
    
    ;Load next stage into RAM         
    mov [disk],dl       
    mov ah, 0x2         ;read sectors
    mov al, 1           ;number of sectors to read
    mov ch, 0           ;cylinder idx
    mov dh, 0           ;head idx
    mov cl, 2           ;sector idx
    mov dl, [disk]      ;disk idx
    mov bx, copy_target
    int 0x13
    
    ;Set up Global Descriptor Table
    cli                 ; Clear interrupts
    lgdt [gdt_pointer]  ; load the gdt table
    mov eax, cr0 
    or eax,0x1          ; set the protected mode bit on special CPU reg cr0
    mov cr0, eax
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	
    
    jmp CODE_SEG:kernel

times 510 - ($-$$) db 0 ; Pad boot sector with 0's

dw 0xaa55               ; Boot signature / bootable "magic number"
                        ; 0x55 and 0xAA. Note little-endian ordering.

;==========================SEGMENT 2==============================
copy_target:
bits 32

hello: db "Hello more than 512 bytes world!!",0
kernel:
	mov esi,hello
	mov ebx,0xb8000
.loop:
	lodsb
	or al,al
	jz halt
	or eax,0x0F00
	mov word [ebx], ax
	add ebx,2
	jmp .loop
halt:
	cli
	hlt

times 1024 - ($-$$) db 0
