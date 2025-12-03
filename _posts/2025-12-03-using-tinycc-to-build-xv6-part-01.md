---
layout: post
title: "Using TinyCC to Build XV6 part 01"
date: 2025-12-03
categories: ['compiler']
author: Jin Yang
---

In my previous post [Learning TinyCC](https://jinyang.hk/compiler/2025/11/20/learning-tinycc.html), I tried to use tcc to compile xv6

The c compiler part works fine, and some asm code; the boot related code compiling, linking and objdump&objcopy jobs have to be done by gcc

So, in other to use tcc to build the whole xv6, below changes are required:

1. assembler change to address below issues
	*  mnemonics instructions like `pushal`, `popal`, `ljmpl` not supported by tcc
	* `.comm` pysedo instruction support or workaround

2. compiler builtin functions like `_sync_synchronize()`

3. special handling for boot:
	* linker support for `-N -e start -Ttext 0x7C00`
	* when `entry.S`, `entryother.S` are compiled by tcc with minor change, qemu won't boot xv6.img
	* utility functions for `objdump`, `objcopy`, `sign.pl`, etc ...
	* make sure `bootblock` size is less than 510 bytes, otherwise it won't fit bootsector


_Last updated: December 3, 2025_
