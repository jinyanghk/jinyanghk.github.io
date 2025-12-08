---
layout: post
title: "Using TinyCC to Build XV6 part 02"
date: 2025-12-04
categories: ['compiler']
author: Jin Yang
---

to be able to enhance tcc assembler, we need to know differences between tcc and gcc assembler,
and why qemu won't boot xv6-tcc.img

```
bootblock: bootasm.S bootmain.c
        $(CC) $(CFLAGS) -fno-pic -O -nostdinc -I. -c bootmain.c
        $(CC) $(CFLAGS) -fno-pic -nostdinc -I. -c bootasm.S
        $(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 -o bootblock.o bootasm.o bootmain.o
        $(OBJDUMP) -S bootblock.o > bootblock.asm
        $(OBJCOPY) -S -O binary -j .text bootblock.o bootblock
        ./sign.pl bootblock
```

[bootblock.asm](https://jinyang.hk/assets/files/bootblock.asm)


[bootblock-tcc.asm](https://jinyang.hk/assets/files/bootblock-tcc.asm)

bootasm.o vs bootasm-tcc.o

```sh
ubuntu@e300d049be55:~/xv6$ objcopy -j ".text" -O binary bootasm.o bootasm.b
ubuntu@e300d049be55:~/xv6$ xxd -ps bootasm.b
fa31c08ed88ec08ed0e464a80275fab0d1e664e464a80275fab0dfe6600f
011678000f20c06683c8010f22c0ea3100080066b810008ed88ec08ed066
b800008ee08ee8bc00000000e8fcffffff66b8008a6689c266ef66b8e08a
66efebfe66900000000000000000ffff0000009acf00ffff00000092cf00
170060000000

ubuntu@e300d049be55:~/xv6$ objcopy -j ".text" -O binary bootasm-tcc.o bootasm-tcc.b
ubuntu@e300d049be55:~/xv6$ xxd -ps bootasm-tcc.b
fa6631c0668ed8668ec0668ed0e464a80275fab0d1e664e464a80275fab0
dfe6600f0115000000000f20c00d010000000f22c0ea00000000080066b8
1000668ed8668ec0668ed066b80000668ee0668ee8bc00000000e8fcffff
ff66b8008a6689c266ef66b8e08a66efebfe0000000000000000ffff0000
009acf00ffff00000092cf00170000000000
```

```sh
ubuntu@e300d049be55:~/xv6$ objdump -S bootasm.o > bootasm.asm
ubuntu@e300d049be55:~/xv6$ objdump -S bootasm-tcc.o > bootasm-tcc.asm
```

[bootasm.asm](https://jinyang.hk/assets/files/bootasm.asm)


[bootasm-tcc.asm](https://jinyang.hk/assets/files/bootasm-tcc.asm)


```sh
ubuntu@e300d049be55:~/xv6$ objdump -S bootmain.o > bootmain.asm
ubuntu@e300d049be55:~/xv6$ objdump -S bootmain-tcc.o > bootmain-tcc.asm
```

[bootmain.asm](https://jinyang.hk/assets/files/bootmain.asm)


[bootmain-tcc.asm](https://jinyang.hk/assets/files/bootmain-tcc.asm)


_Last updated: December 8, 2025_
