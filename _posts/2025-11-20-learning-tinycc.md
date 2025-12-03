---
layout: post
title: "Learning TinyCC"
date: 2025-11-20
categories: ['compiler']
author: Jin Yang
---

![](/assets/images/tinycc/tcc-logo.png)

[Fabrice Bellard](https://bellard.org)'s [tinycc](https://www.bellard.org/tcc/) is still being developed at 
https://repo.or.cz/tinycc.git

I was curious if tinycc can build an OS ... 

There was a [tccboot](https://bellard.org/tcc/tccboot.html) project, but that was long time ago, and it was for very old linux kernel

now I'm wondering if current tinycc can build a simpler OS, like [xv6](https://github.com/mit-pdos/xv6-public) ...

it turns out it's not as easy as I thought, I managed to compile part of it and get it run in qemu

files compiled by tinycc:

* most of kernel c language source files, except `spinlock.c`
* most of user program source files, except `usertests.c`

files compiled by gcc:

* all boot releated files
* all assembly language source files
* mkfs



```sh
ubuntu@e300d049be55:~/xv6$ make clean
rm -f *.tex *.dvi *.idx *.aux *.log *.ind *.ilg \
*.o *.d *.asm *.sym vectors.S bootblock entryother \
initcode initcode.out kernel xv6.img fs.img kernelmemfs \
xv6memfs.img mkfs .gdbinit \
_cat _echo _forktest _grep _init _kill _ln _ls _mkdir _rm _sh _stressfs
ubuntu@e300d049be55:~/xv6$ make qemu-nox
gcc -Werror -Wall -o mkfs mkfs.c
tcc -nostdinc -I. -c ulib.c -o ulib.o
gcc -m32 -gdwarf-2 -Wa,-divide   -c -o usys.o usys.S
tcc -nostdinc -I. -c printf.c -o printf.o
tcc -nostdinc -I. -c umalloc.c -o umalloc.o
tcc -nostdinc -I. -c cat.c -o cat.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _cat cat.o ulib.o usys.o printf.o umalloc.o
objdump -S _cat > cat.asm
objdump -t _cat | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > cat.sym
tcc -nostdinc -I. -c echo.c -o echo.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _echo echo.o ulib.o usys.o printf.o umalloc.o
objdump -S _echo > echo.asm
objdump -t _echo | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > echo.sym
tcc -nostdinc -I. -c forktest.c -o forktest.o
# forktest has less library code linked in - needs to be small
# in order to be able to max out the proc table.
ld -m    elf_i386 -N -e main -Ttext 0 -o _forktest forktest.o ulib.o usys.o
objdump -S _forktest > forktest.asm
tcc -nostdinc -I. -c grep.c -o grep.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _grep grep.o ulib.o usys.o printf.o umalloc.o
objdump -S _grep > grep.asm
objdump -t _grep | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > grep.sym
tcc -nostdinc -I. -c init.c -o init.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _init init.o ulib.o usys.o printf.o umalloc.o
objdump -S _init > init.asm
objdump -t _init | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > init.sym
tcc -nostdinc -I. -c kill.c -o kill.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _kill kill.o ulib.o usys.o printf.o umalloc.o
objdump -S _kill > kill.asm
objdump -t _kill | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > kill.sym
tcc -nostdinc -I. -c ln.c -o ln.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _ln ln.o ulib.o usys.o printf.o umalloc.o
objdump -S _ln > ln.asm
objdump -t _ln | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > ln.sym
tcc -nostdinc -I. -c ls.c -o ls.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _ls ls.o ulib.o usys.o printf.o umalloc.o
objdump -S _ls > ls.asm
objdump -t _ls | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > ls.sym
tcc -nostdinc -I. -c mkdir.c -o mkdir.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _mkdir mkdir.o ulib.o usys.o printf.o umalloc.o
objdump -S _mkdir > mkdir.asm
objdump -t _mkdir | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > mkdir.sym
tcc -nostdinc -I. -c rm.c -o rm.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _rm rm.o ulib.o usys.o printf.o umalloc.o
objdump -S _rm > rm.asm
objdump -t _rm | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > rm.sym
tcc -nostdinc -I. -c sh.c -o sh.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _sh sh.o ulib.o usys.o printf.o umalloc.o
objdump -S _sh > sh.asm
objdump -t _sh | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > sh.sym
tcc -nostdinc -I. -c stressfs.c -o stressfs.o
ld -m    elf_i386 -N -e main -Ttext 0 -o _stressfs stressfs.o ulib.o usys.o printf.o umalloc.o
objdump -S _stressfs > stressfs.asm
objdump -t _stressfs | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > stressfs.sym
./mkfs fs.img README _cat _echo _forktest _grep _init _kill _ln _ls _mkdir _rm _sh _stressfs
nmeta 59 (boot, super, log blocks 30 inode blocks 26, bitmap blocks 1) blocks 941 total 1000
balloc: first 215 blocks have been allocated
balloc: write bitmap block at sector 58
gcc -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer -fno-stack-protector -fno-pie -no-pie -fno-pic -O -nostdinc -I. -c bootmain.c
gcc -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer -fno-stack-protector -fno-pie -no-pie -fno-pic -nostdinc -I. -c bootasm.S
ld -m    elf_i386 -N -e start -Ttext 0x7C00 -o bootblock.o bootasm.o bootmain.o
objdump -S bootblock.o > bootblock.asm
objcopy -S -O binary -j .text bootblock.o bootblock
./sign.pl bootblock
boot block is 448 bytes (max 510)
tcc -nostdinc -I. -c bio.c -o bio.o
tcc -nostdinc -I. -c console.c -o console.o
tcc -nostdinc -I. -c exec.c -o exec.o
tcc -nostdinc -I. -c file.c -o file.o
tcc -nostdinc -I. -c fs.c -o fs.o
tcc -nostdinc -I. -c ide.c -o ide.o
tcc -nostdinc -I. -c ioapic.c -o ioapic.o
tcc -nostdinc -I. -c kalloc.c -o kalloc.o
tcc -nostdinc -I. -c kbd.c -o kbd.o
tcc -nostdinc -I. -c lapic.c -o lapic.o
tcc -nostdinc -I. -c log.c -o log.o
tcc -nostdinc -I. -c main.c -o main.o
tcc -nostdinc -I. -c mp.c -o mp.o
tcc -nostdinc -I. -c picirq.c -o picirq.o
tcc -nostdinc -I. -c pipe.c -o pipe.o
tcc -nostdinc -I. -c proc.c -o proc.o
tcc -nostdinc -I. -c sleeplock.c -o sleeplock.o
tcc -nostdinc -I. -c spinlock.c -o spinlock.o
tcc -nostdinc -I. -c string.c -o string.o
gcc -m32 -gdwarf-2 -Wa,-divide   -c -o swtch.o swtch.S
tcc -nostdinc -I. -c syscall.c -o syscall.o
tcc -nostdinc -I. -c sysfile.c -o sysfile.o
tcc -nostdinc -I. -c sysproc.c -o sysproc.o
gcc -m32 -gdwarf-2 -Wa,-divide   -c -o trapasm.o trapasm.S
tcc -nostdinc -I. -c trap.c -o trap.o
tcc -nostdinc -I. -c uart.c -o uart.o
./vectors.pl > vectors.S
gcc -m32 -gdwarf-2 -Wa,-divide   -c -o vectors.o vectors.S
tcc -nostdinc -I. -c vm.c -o vm.o
gcc -m32 -gdwarf-2 -Wa,-divide   -c -o entry.o entry.S
gcc -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer -fno-stack-protector -fno-pie -no-pie -fno-pic -nostdinc -I. -c entryother.S
ld -m    elf_i386 -N -e start -Ttext 0x7000 -o bootblockother.o entryother.o
objcopy -S -O binary -j .text bootblockother.o entryother
objdump -S bootblockother.o > entryother.asm
gcc -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer -fno-stack-protector -fno-pie -no-pie -nostdinc -I. -c initcode.S
ld -m    elf_i386 -N -e start -Ttext 0 -o initcode.out initcode.o
objcopy -S -O binary initcode.out initcode
objdump -S initcode.o > initcode.asm
ld -m    elf_i386 -T kernel.ld -o kernel entry.o bio.o console.o exec.o file.o fs.o ide.o ioapic.o kalloc.o kbd.o lapic.o log.o main.o mp.o picirq.o pipe.o proc.o sleeplock.o spinlock.o string.o swtch.o syscall.o sysfile.o sysproc.o trapasm.o trap.o uart.o vectors.o vm.o  -b binary initcode entryother
objdump -S kernel > kernel.asm
objdump -t kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$/d' > kernel.sym
dd if=/dev/zero of=xv6.img count=10000
10000+0 records in
10000+0 records out
5120000 bytes (5.1 MB, 4.9 MiB) copied, 0.00569621 s, 899 MB/s
dd if=bootblock of=xv6.img conv=notrunc
1+0 records in
1+0 records out
512 bytes copied, 3.7908e-05 s, 13.5 MB/s
dd if=kernel of=xv6.img seek=1 conv=notrunc
149+1 records in
149+1 records out
76512 bytes (77 kB, 75 KiB) copied, 0.000123241 s, 621 MB/s
qemu-system-i386 -nographic -drive file=fs.img,index=1,media=disk,format=raw -drive file=xv6.img,index=0,media=disk,format=raw -smp 2 -m 512
xv6...
cpu1: starting 1
cpu0: starting 0
sb: size 1000 nblocks 941 ninodes 200 nlog 30 logstart 2 inodestart 32 bmap start 58
init: starting sh
$ ls
.              1 1 512
..             1 1 512
README         2 2 2286
cat            2 3 5728
echo           2 4 5400
forktest       2 5 3824
grep           2 6 6520
init           2 7 5808
kill           2 8 5360
ln             2 9 5404
ls             2 10 6520
mkdir          2 11 5456
rm             2 12 5452
sh             2 13 10888
stressfs       2 14 5756
console        3 15 0
$ QEMU: Terminated
ubuntu@e300d049be55:~/xv6$
```

_Last updated: December 2, 2025_
