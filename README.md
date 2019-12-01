# boot-popcorn
Operating Systems project

## Build instructions
Building requires `nasm` to assemble the assembly code.

To build, run `nasm -f bin boot.asm -o boot.bin`

This will use NASM to assemble `boot.asm` into a binary executable called `boot.bin`.


## Run instructions
Running the binary requires QEMU.  On your system you may be able to use either the command `qemu` or `qemu-system-x86_64`.

To boot from the binary, run `qemu-system-x86_64 boot.bin`

---

## Kernel test build instructions

Create object files from kernel.asm and kernel.c and then link it using our linker script.

> nasm -f elf32 kernel.asm -o kasm.o

will run the assembler to create the object file kasm.o in ELF-32 bit format.

> gcc -m32 -c kernel.c -o kc.o

The ’-c ’ option makes sure that after compiling, linking doesn’t implicitly happen.

> ld -m elf_i386 -T link.ld -o kernel kasm.o kc.o

will run the linker with our linker script and generate the executable named kernel.

Finally, to run the kernel with our emulator, run this command

> qemu-system-x86_64 -kernel kernel