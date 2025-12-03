---
layout: post
title: "Using TinyCC to Build XV6 part 01"
date: 2025-12-03
categories: ['compiler']
author: Jin Yang
---

In my previous post [Learning TinyCC](https://jinyang.hk/compiler/2025/11/20/learning-tinycc.html), I tried to use tcc to compile xv6

The c compiler part works fine, and some asm; the boot related code compiling, linking and objdump&objcopy jobs have to be done by gcc

So, in other to make tcc to build the whole xv6, below changes are required:

1. assembler change to address below issues
	a. mnemonics instructions like `pushal`, `popal`, `ljmpl` not supported by tcc
	b. `.comm` pysedo instruction support or workaround


2. builtin functions like `_sync_synchronize()`

3. linker support for `-N -e start -Ttext 0x7C00`

4. special handling for boot:
	a. `-fno-pic` support for compiler, assembler, linker
	b. utility functions for `objdump`, `objcopy`
	c. make sure `bootblock` size is less than 510 bytes, otherwise it won't fit bootsector


_Last updated: December 3, 2025_
