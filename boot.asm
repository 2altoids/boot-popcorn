;********************;
; POPCORN BOOTLOADER ;
;********************;

section .boot

bits 16             ; The bootloader begins in 16 bit real mode

global start        ; start label as entrypoint in linker script


; Entry point
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
    db 0x0          ; base high
gdt_end:

gdt_pointer:
    dw gdt_end - gdt_start          ; GDT size, 16 bit field
    dd gdt_start                    ; 32 bit pointer to GDT
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
;******************************************;


; Boot sector data
msg:                db "Boot sector: Executing Stage 1...", 13, 10, 0
disk_error_msg:     db "Disk read error", 0
sectors_error_msg:  db "Incorrect number of sectors read", 0
disk:               db 0x00 ; 0 is the code for first floppy drive


;Print routine
print:
    lodsb           ; Load next byte in string
    or al, al       ; If byte is 0, return, else print character.
    jz print_done
    mov ah, 0x0e
    int 0x10
    jmp print
print_done:
    ret


; Disk read error routines
disk_error:
    mov si, disk_error_msg
    call print
    jmp $

sectors_error:
    mov si, sectors_error_msg
    call print
    jmp $


; Begin bootloading
main:
    mov ax, 0x2401      ; Activate A20 line
	int 0x15
	
    mov ax, 0x3         ; Set VGA mode to safe value (text mode 3)
	int 0x10
    
    mov bp, 0x8000      ; Move the stack far away
    mov sp, bp
    
    mov si, msg         ; Print boot sector message
    call print
    
    ;Load next stage into RAM         
    mov [disk],dl       
    mov ah, 0x2         ;read sectors
    mov al, 6           ;number of sectors to read
    mov ch, 0           ;cylinder index
    mov dh, 0           ;head index
    mov cl, 2           ;sector index
    mov dl, [disk]      ;disk index
    mov bx, copy_target
    int 0x13
    
    ;Set up Global Descriptor Table
    cli                 ; Clear interrupts
    lgdt [gdt_pointer]  ; load the gdt table
    mov eax, cr0 
    or eax, 0x1         ; set the protected mode bit on special CPU reg cr0
    mov cr0, eax
	mov ax, DATA_SEG    ; set each segment pointer to 
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

hello: db "Hello more than 512 bytes world!!", 0

kernel:
    ; Print hello message
	mov esi, hello
	mov ebx, 0xb80a0 ; Start printing at second row of vga so msg from boot sector isn't overwritten
.loop:
    ; Print each character of message until 0 is reached
	lodsb
	or al, al
	jz halt
	or eax, 0x0F00
	mov word [ebx], ax
	add ebx, 2
	jmp .loop
halt:
    ; Set up stack for kernel, then call kernel main function
    mov esp, kernel_stack_top
	extern kernel_main
	call kernel_main
    
    ; Kernel ends, halt
	cli
	hlt


section .bss
align 4
kernel_stack_bottom: equ $
    resb 16384 ; 16 KB
kernel_stack_top:
