# Meaty Skeleton Tutorial
This tutorial is found on the OSDev Wiki [here](https://wiki.osdev.org/Meaty_Skeleton) and builds on the Bare Bones
tutorial found [here](https://wiki.osdev.org/Bare_Bones). The original git repository can be viewed and cloned from
[GitLab](https://gitlab.com/sortie/meaty-skeleton).

## Instructions
`./clean.sh` to clean previous build.
`./headers.sh` to set up system headers.
`./iso.sh` to build kernel image.
`./qemu.sh` to run kernel image in qemu.

If you want to run just the kernel binary then: `qemu-system-i386 -kernel 
./isodir/boot/myos.kernel`.

## Disclaimer
Building the code in this tutorial does require an i686-elf cross-compiler, which can be built by following
the GCC Cross-Compiler tutorial [here](https://wiki.osdev.org/GCC_Cross-Compiler). The location of the cross-compiler
should be updated in `/default-host.sh`.
