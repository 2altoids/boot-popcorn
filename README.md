# boot-popcorn
Operating Systems project

## Build instructions
Building requires `nasm` to assemble the assembly code.

To build, run `nasm -f bin boot_sector.asm -o boot_sector.bin`

This will use NASM to assemble `boot_sector.asm` into a binary executable called `boot_sector.bin`.


## Run instructions
Running the binary requires QEMU.  On your system you may be able to use either the command `qemu` or `qemu-system-x86_64`.

To boot from the binary, run `qemu-system-x86_64 boot_sector.bin`
