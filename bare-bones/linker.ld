/**
 * This code was found at wiki.osdev.org/User:Zesterer/Bare_Bones.
 * Invoke with: i686-elf-gcc -ffreestanding -nostdlib -g -T linker.ld start.o kernel.o -o mykernel.elf
 * -lgcc
 */

ENTRY(start)

SECTIONS {
    . = 1M;
    .rodata BLOCK(4K) : ALIGN(4K) {
        *(.multiboot)
    }
    .text BLOCK(4K) : ALIGN(4K) {
        *(.text)
    }
    .rodata BLOCK(4K) : ALIGN(4K) {
        *(.rodata)
    }
    .data BLOCK(4K) : ALIGN(4K) {
        *(.data)
    }
    .bss BLOCK(4K) : ALIGN(4K) {
        *(COMMON)
        *(.bss)
    }
}
