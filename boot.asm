;********************;
; POPCORN BOOTLOADER ;
;********************;

org 0x7c00              ; The BIOS loads the boot sector at 0x7c00

bits 16                 ; The bootloader begins in 16 bit real mode


start:
    jmp loader



TIMES 0x0b - $ + start db 0

;***********BIOS Partition Table***********;
; This 
bpbBytesPerSector:  	dw 512
bpbSectorsPerCluster: 	db 1
bpbReservedSectors: 	dw 1
bpbNumberOfFATs: 	    db 2
bpbRootEntries: 	    dw 224
bpbTotalSectors: 	    dw 2880
bpbMedia: 	            db 0xf0
bpbSectorsPerFAT: 	    dw 9
bpbSectorsPerTrack: 	dw 18
bpbHeadsPerCylinder: 	dw 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        db 0
bsUnused: 	            db 0
bsExtBootSignature: 	db 0x29
bsSerialNumber:	        dd 0xa0a1a2a3
bsVolumeLabel: 	        db "POPCORNBOOT"
bsFileSystem: 	        db "FAT12   "
;******************************************;


msg:                    db "Boot sector:  Executing Stage 1...", 0


;Print routine
print:
    lodsb               ; Load next byte in string
    or al, al           ; If byte is 0, return, else print character.
    jz printDone
    mov ah, 0x0e
    int 0x10
    jmp print
printDone:
    ret


loader:
    xor ax, ax          ; Null segment registers, no offsets required
    mov ds, ax
    mov es, ax
    
    mov si, msg         ; Print message string at msg
    call print

    cli                 ; Clear all interrupts
    hlt                 ; Halt the system

times 510 - ($-$$) db 0 ; Pad boot sector with 0's

dw 0xaa55               ; Boot signature / bootable "magic number"
                        ; 0x55 and 0xAA. Note little-endian ordering.
                        
                        
                        
                        
                        
                        

