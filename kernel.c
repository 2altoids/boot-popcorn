/**
 * This code was modified from the code found at https://wiki.osdev.org/User:Zesterer/Bare_Bones.
 * Compile with: i686-elf-gcc -std=gnu99 -ffreestanding -g -c kernel.c -o kernel.o
 */

#include <stddef.h>
#include <stdint.h>

#if defined(__linux__)
    #error "This code must be compiled with a cross compiler"
#elif !defined(__i386__)
    #error "This code must be compiled with an x86-elf compiler"
#endif

volatile uint16_t* vga_buffer = (uint16_t*)0xB8000;
const int VGA_COLS = 80;
const int VGA_ROWS = 25;

int term_col = 0;
int term_row = 0;
uint8_t term_color = 0x4E; // set text background to black and foreground to yellow

// Print a character to the terminal.
void term_putc(char c) {
    switch (c) {
        case '\n': {
            term_col = 0;
            term_row++;
            break;
        }
        default: {
            const size_t index = (VGA_COLS * term_row) + term_col;
            vga_buffer[index] = ((uint16_t)term_color << 8) | c;
            term_col++;
            break;
        }
    }
    
    if (term_col >= VGA_COLS) {
        term_col = 0;
        term_row++;
    }
    if (term_row >= VGA_ROWS) {
        term_col = 0;
        term_row = 0;
    }
}

// Print a string to the terminal.
void term_print(const char* str) {
    for (size_t i = 0; str[i] != '\0'; i++) {
        term_putc(str[i]);
    }
}

void kernel_main() {
    term_row++; // skip the row printed out by the boot sector
    term_row++; // skip the row printed out by the second-stage bootloader
    term_print(" _ __   ___  _ __   ___ ___  _ __ _ __  \n");
    term_print("| '_ \\ / _ \\| '_ \\ / __/ _ \\| '__| '_ \\ \n");
    term_print("| |_) | (_) | |_) | (_| (_) | |  | | | |\n");
    term_print("| .__/ \\___/| .__/ \\___\\___/|_|  |_| |_|\n");
    term_print("| |         | |                         \n");
    term_print("|_|         |_|                         \n");
    // term_print("**********************************\n");
    // term_print("* Welcome to the Popcorn kernel! *\n");
    // term_print("**********************************\n");
}
