#!/bin/sh
set -e
. ./build.sh

mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub

cp sysroot/boot/meatyskeleton.kernel isodir/boot/meatyskeleton.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "meatyskeleton" {
    multiboot /boot/meatyskeleton.kernel
}
EOF
grub-mkrescue -o meatyskeleton.iso isodir
