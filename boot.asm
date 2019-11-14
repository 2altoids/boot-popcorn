;********************;
; POPCORN BOOTLOADER ;
;********************;

org 0x7c00              ; The BIOS loads the boot sector at 0x7c00

bits 16                 ; The bootloader begins in 16 bit real mode

start:
    mov ah, 0x0e        ; Teletype output function code for INT 0x10
    mov al, 'H'
    int 0x10            ; Execute video interrupt 0x10
    mov al, 'E'
    int 0x10
    mov al, 'L'
    int 0x10
    int 0x10
    mov al, 'O'
    int 0x10

    jmp $               ; Jump to current address.  Infinite loop.

times 510 - ($-$$) db 0 ; Pad boot sector with 0's

dw 0xaa55               ; Boot signature / bootable "magic number"
                        ; 0x55 and 0xAA. Note little-endian ordering.