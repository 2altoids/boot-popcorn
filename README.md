# boot-popcorn
The **Popcorn Bootloader & Kernel**, or boot-popcorn for short, is an Operating Systems class project, comprised of a simple bootloader and a minimal 32-bit kernel, written for x86 family processors.

Boot-popcorn was created as a proof-of-concept to show what it takes to get a PC to boot, from pressing the power button to running arbitrary compiled code.

## Requirements
Building and running this project requires the assembler `nasm`, the emulator `qemu`, and a cross-compiler build of `gcc` specially configured for OS dev.  The former two may be available in your package manager already.  It is possible to use Windows, but it is much easier to use a Linux environment.

`nasm` can be downloaded from the [Netwide Assembler website](https://nasm.us/).

`qemu` can be downloaded from the [QEMU website](https://www.qemu.org/).

To get the cross-compiler you need, follow the directions on [this OSDev Wiki article](https://wiki.osdev.org/GCC_Cross-Compiler).  You can download the latest `gcc` source code from [here](https://ftp.gnu.org/gnu/gcc/) and the latest `binutils` source code from [here](https://ftp.gnu.org/gnu/binutils/).

## Build instructions
Building requires `nasm` to assemble the assembly code.

To build, first run NASM to form the assembly code into an object suitable for linking:

> nasm -f elf32 boot.asm -o boot.o

This will create an object file named `boot.o`.  Afterwards, use your `gcc` cross-compiler 
(whatever it may be called) to compile the C++ code and link it to `boot.o`:

> i686-elf-gcc -m32 kmain.cpp boot.o -o kernel.bin -nostdlib -ffreestanding -std=c++11 -mno-red-zone -fno-exceptions -fno-rtti -Wall -Wextra -Werror -T linker.ld

And to compile the C version:

> i686-elf-gcc -m32 kernel.c boot.o -o kernel.bin -nostdlib -ffreestanding -std=gnu11 
-mno-red-zone -fno-exceptions -Wall -Wextra -Werror -T linker.ld

## Run instructions
Running the binary requires QEMU.  On your system you may be able to use either the command `qemu` or `qemu-system-x86_64`.

To boot from the binary, run QEMU:

> qemu-system-x86_64 -fda kernel.bin

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

## Acknowledgements, sources, and further reading
* [_Writing a Bootloader_ by Alex Parker](http://3zanders.co.uk/2017/10/13/writing-a-bootloader/)
* [os-tutorial on GitHub by Carlos Fenollosa](https://github.com/cfenollosa/os-tutorial)
* [OS Development Series by Mike from BrokenThorn Entertainment](http://brokenthorn.com/Resources/OSDevIndex.html)
* [OSDev Wiki](https://wiki.osdev.org/Main_Page)
* [_The world of Protected Mode_ by Gregor Brunmar](http://www.osdever.net/tutorials/view/the-world-of-protected-mode)
