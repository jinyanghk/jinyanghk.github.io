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

bootblock.asm

```asm

bootblock.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
    7c00:       fa                      cli

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
    7c01:       31 c0                   xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
    7c03:       8e d8                   mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
    7c05:       8e c0                   mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
    7c07:       8e d0                   mov    %eax,%ss

00007c09 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
    7c09:       e4 64                   in     $0x64,%al
  testb   $0x2,%al
    7c0b:       a8 02                   test   $0x2,%al
  jnz     seta20.1
    7c0d:       75 fa                   jne    7c09 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
    7c0f:       b0 d1                   mov    $0xd1,%al
  outb    %al,$0x64
    7c11:       e6 64                   out    %al,$0x64

00007c13 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
    7c13:       e4 64                   in     $0x64,%al
  testb   $0x2,%al
    7c15:       a8 02                   test   $0x2,%al
  jnz     seta20.2
    7c17:       75 fa                   jne    7c13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
    7c19:       b0 df                   mov    $0xdf,%al
  outb    %al,$0x60
    7c1b:       e6 60                   out    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
    7c1d:       0f 01 16                lgdtl  (%esi)
    7c20:       78 7c                   js     7c9e <readsect+0xe>
  movl    %cr0, %eax
    7c22:       0f 20 c0                mov    %cr0,%eax
  orl     $CR0_PE, %eax
    7c25:       66 83 c8 01             or     $0x1,%ax
  movl    %eax, %cr0
    7c29:       0f 22 c0                mov    %eax,%cr0

//PAGEBREAK!
  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
    7c2c:       ea                      .byte 0xea
    7c2d:       31 7c 08 00             xor    %edi,0x0(%eax,%ecx,1)

00007c31 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
    7c31:       66 b8 10 00             mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
    7c35:       8e d8                   mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
    7c37:       8e c0                   mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
    7c39:       8e d0                   mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
    7c3b:       66 b8 00 00             mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
    7c3f:       8e e0                   mov    %eax,%fs
  movw    %ax, %gs                # -> GS
    7c41:       8e e8                   mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
    7c43:       bc 00 7c 00 00          mov    $0x7c00,%esp
  call    bootmain
    7c48:       e8 ee 00 00 00          call   7d3b <bootmain>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
    7c4d:       66 b8 00 8a             mov    $0x8a00,%ax
  movw    %ax, %dx
    7c51:       66 89 c2                mov    %ax,%dx
  outw    %ax, %dx
    7c54:       66 ef                   out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
    7c56:       66 b8 e0 8a             mov    $0x8ae0,%ax
  outw    %ax, %dx
    7c5a:       66 ef                   out    %ax,(%dx)

00007c5c <spin>:
spin:
  jmp     spin
    7c5c:       eb fe                   jmp    7c5c <spin>
    7c5e:       66 90                   xchg   %ax,%ax

00007c60 <gdt>:
        ...
    7c68:       ff                      (bad)
    7c69:       ff 00                   incl   (%eax)
    7c6b:       00 00                   add    %al,(%eax)
    7c6d:       9a cf 00 ff ff 00 00    lcall  $0x0,$0xffff00cf
    7c74:       00                      .byte 0x0
    7c75:       92                      xchg   %eax,%edx
    7c76:       cf                      iret
        ...

00007c78 <gdtdesc>:
    7c78:       17                      pop    %ss
    7c79:       00 60 7c                add    %ah,0x7c(%eax)
        ...

00007c7e <waitdisk>:
  entry();
}

void
waitdisk(void)
{
    7c7e:       55                      push   %ebp
    7c7f:       89 e5                   mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
    7c81:       ba f7 01 00 00          mov    $0x1f7,%edx
    7c86:       ec                      in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
    7c87:       83 e0 c0                and    $0xffffffc0,%eax
    7c8a:       3c 40                   cmp    $0x40,%al
    7c8c:       75 f8                   jne    7c86 <waitdisk+0x8>
    ;
}
    7c8e:       5d                      pop    %ebp
    7c8f:       c3                      ret

00007c90 <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
    7c90:       55                      push   %ebp
    7c91:       89 e5                   mov    %esp,%ebp
    7c93:       57                      push   %edi
    7c94:       53                      push   %ebx
    7c95:       8b 5d 0c                mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
    7c98:       e8 e1 ff ff ff          call   7c7e <waitdisk>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
    7c9d:       b8 01 00 00 00          mov    $0x1,%eax
    7ca2:       ba f2 01 00 00          mov    $0x1f2,%edx
    7ca7:       ee                      out    %al,(%dx)
    7ca8:       ba f3 01 00 00          mov    $0x1f3,%edx
    7cad:       89 d8                   mov    %ebx,%eax
    7caf:       ee                      out    %al,(%dx)
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
    7cb0:       89 d8                   mov    %ebx,%eax
    7cb2:       c1 e8 08                shr    $0x8,%eax
    7cb5:       ba f4 01 00 00          mov    $0x1f4,%edx
    7cba:       ee                      out    %al,(%dx)
  outb(0x1F5, offset >> 16);
    7cbb:       89 d8                   mov    %ebx,%eax
    7cbd:       c1 e8 10                shr    $0x10,%eax
    7cc0:       ba f5 01 00 00          mov    $0x1f5,%edx
    7cc5:       ee                      out    %al,(%dx)
  outb(0x1F6, (offset >> 24) | 0xE0);
    7cc6:       89 d8                   mov    %ebx,%eax
    7cc8:       c1 e8 18                shr    $0x18,%eax
    7ccb:       83 c8 e0                or     $0xffffffe0,%eax
    7cce:       ba f6 01 00 00          mov    $0x1f6,%edx
    7cd3:       ee                      out    %al,(%dx)
    7cd4:       b8 20 00 00 00          mov    $0x20,%eax
    7cd9:       ba f7 01 00 00          mov    $0x1f7,%edx
    7cde:       ee                      out    %al,(%dx)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
    7cdf:       e8 9a ff ff ff          call   7c7e <waitdisk>
  asm volatile("cld; rep insl" :
    7ce4:       8b 7d 08                mov    0x8(%ebp),%edi
    7ce7:       b9 80 00 00 00          mov    $0x80,%ecx
    7cec:       ba f0 01 00 00          mov    $0x1f0,%edx
    7cf1:       fc                      cld
    7cf2:       f3 6d                   rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
    7cf4:       5b                      pop    %ebx
    7cf5:       5f                      pop    %edi
    7cf6:       5d                      pop    %ebp
    7cf7:       c3                      ret

00007cf8 <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
    7cf8:       55                      push   %ebp
    7cf9:       89 e5                   mov    %esp,%ebp
    7cfb:       57                      push   %edi
    7cfc:       56                      push   %esi
    7cfd:       53                      push   %ebx
    7cfe:       8b 5d 08                mov    0x8(%ebp),%ebx
    7d01:       8b 75 10                mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
    7d04:       89 df                   mov    %ebx,%edi
    7d06:       03 7d 0c                add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
    7d09:       89 f0                   mov    %esi,%eax
    7d0b:       25 ff 01 00 00          and    $0x1ff,%eax
    7d10:       29 c3                   sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
    7d12:       c1 ee 09                shr    $0x9,%esi
    7d15:       83 c6 01                add    $0x1,%esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d18:       39 df                   cmp    %ebx,%edi
    7d1a:       76 17                   jbe    7d33 <readseg+0x3b>
    readsect(pa, offset);
    7d1c:       56                      push   %esi
    7d1d:       53                      push   %ebx
    7d1e:       e8 6d ff ff ff          call   7c90 <readsect>
  for(; pa < epa; pa += SECTSIZE, offset++)
    7d23:       81 c3 00 02 00 00       add    $0x200,%ebx
    7d29:       83 c6 01                add    $0x1,%esi
    7d2c:       83 c4 08                add    $0x8,%esp
    7d2f:       39 df                   cmp    %ebx,%edi
    7d31:       77 e9                   ja     7d1c <readseg+0x24>
}
    7d33:       8d 65 f4                lea    -0xc(%ebp),%esp
    7d36:       5b                      pop    %ebx
    7d37:       5e                      pop    %esi
    7d38:       5f                      pop    %edi
    7d39:       5d                      pop    %ebp
    7d3a:       c3                      ret

00007d3b <bootmain>:
{
    7d3b:       55                      push   %ebp
    7d3c:       89 e5                   mov    %esp,%ebp
    7d3e:       57                      push   %edi
    7d3f:       56                      push   %esi
    7d40:       53                      push   %ebx
    7d41:       83 ec 0c                sub    $0xc,%esp
  readseg((uchar*)elf, 4096, 0);
    7d44:       6a 00                   push   $0x0
    7d46:       68 00 10 00 00          push   $0x1000
    7d4b:       68 00 00 01 00          push   $0x10000
    7d50:       e8 a3 ff ff ff          call   7cf8 <readseg>
  if(elf->magic != ELF_MAGIC)
    7d55:       83 c4 0c                add    $0xc,%esp
    7d58:       81 3d 00 00 01 00 7f    cmpl   $0x464c457f,0x10000
    7d5f:       45 4c 46
    7d62:       74 08                   je     7d6c <bootmain+0x31>
}
    7d64:       8d 65 f4                lea    -0xc(%ebp),%esp
    7d67:       5b                      pop    %ebx
    7d68:       5e                      pop    %esi
    7d69:       5f                      pop    %edi
    7d6a:       5d                      pop    %ebp
    7d6b:       c3                      ret
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
    7d6c:       a1 1c 00 01 00          mov    0x1001c,%eax
    7d71:       8d 98 00 00 01 00       lea    0x10000(%eax),%ebx
  eph = ph + elf->phnum;
    7d77:       0f b7 35 2c 00 01 00    movzwl 0x1002c,%esi
    7d7e:       c1 e6 05                shl    $0x5,%esi
    7d81:       01 de                   add    %ebx,%esi
  for(; ph < eph; ph++){
    7d83:       39 f3                   cmp    %esi,%ebx
    7d85:       72 0f                   jb     7d96 <bootmain+0x5b>
  entry();
    7d87:       ff 15 18 00 01 00       call   *0x10018
    7d8d:       eb d5                   jmp    7d64 <bootmain+0x29>
  for(; ph < eph; ph++){
    7d8f:       83 c3 20                add    $0x20,%ebx
    7d92:       39 de                   cmp    %ebx,%esi
    7d94:       76 f1                   jbe    7d87 <bootmain+0x4c>
    pa = (uchar*)ph->paddr;
    7d96:       8b 7b 0c                mov    0xc(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
    7d99:       ff 73 04                pushl  0x4(%ebx)
    7d9c:       ff 73 10                pushl  0x10(%ebx)
    7d9f:       57                      push   %edi
    7da0:       e8 53 ff ff ff          call   7cf8 <readseg>
    if(ph->memsz > ph->filesz)
    7da5:       8b 4b 14                mov    0x14(%ebx),%ecx
    7da8:       8b 43 10                mov    0x10(%ebx),%eax
    7dab:       83 c4 0c                add    $0xc,%esp
    7dae:       39 c1                   cmp    %eax,%ecx
    7db0:       76 dd                   jbe    7d8f <bootmain+0x54>
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
    7db2:       01 c7                   add    %eax,%edi
    7db4:       29 c1                   sub    %eax,%ecx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    7db6:       b8 00 00 00 00          mov    $0x0,%eax
    7dbb:       fc                      cld
    7dbc:       f3 aa                   rep stos %al,%es:(%edi)
    7dbe:       eb cf                   jmp    7d8f <bootmain+0x54>
```

bootblock-tcc.asm

```asm

bootblock-tcc.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
    7c00:       fa                      cli
    7c01:       66 31 c0                xor    %ax,%ax
    7c04:       66 8e d8                mov    %ax,%ds
    7c07:       66 8e c0                mov    %ax,%es
    7c0a:       66 8e d0                mov    %ax,%ss

00007c0d <seta20.1>:
    7c0d:       e4 64                   in     $0x64,%al
    7c0f:       a8 02                   test   $0x2,%al
    7c11:       75 fa                   jne    7c0d <seta20.1>
    7c13:       b0 d1                   mov    $0xd1,%al
    7c15:       e6 64                   out    %al,$0x64

00007c17 <seta20.2>:
    7c17:       e4 64                   in     $0x64,%al
    7c19:       a8 02                   test   $0x2,%al
    7c1b:       75 fa                   jne    7c17 <seta20.2>
    7c1d:       b0 df                   mov    $0xdf,%al
    7c1f:       e6 60                   out    %al,$0x60
    7c21:       0f 01 15 84 7c 00 00    lgdtl  0x7c84
    7c28:       0f 20 c0                mov    %cr0,%eax
    7c2b:       0d 01 00 00 00          or     $0x1,%eax
    7c30:       0f 22 c0                mov    %eax,%cr0
    7c33:       ea 3a 7c 00 00 08 00    ljmp   $0x8,$0x7c3a

00007c3a <start32>:
    7c3a:       66 b8 10 00             mov    $0x10,%ax
    7c3e:       66 8e d8                mov    %ax,%ds
    7c41:       66 8e c0                mov    %ax,%es
    7c44:       66 8e d0                mov    %ax,%ss
    7c47:       66 b8 00 00             mov    $0x0,%ax
    7c4b:       66 8e e0                mov    %ax,%fs
    7c4e:       66 8e e8                mov    %ax,%gs
    7c51:       bc 00 7c 00 00          mov    $0x7c00,%esp
    7c56:       e8 31 00 00 00          call   7c8c <bootmain>
    7c5b:       66 b8 00 8a             mov    $0x8a00,%ax
    7c5f:       66 89 c2                mov    %ax,%dx
    7c62:       66 ef                   out    %ax,(%dx)
    7c64:       66 b8 e0 8a             mov    $0x8ae0,%ax
    7c68:       66 ef                   out    %ax,(%dx)

00007c6a <spin>:
    7c6a:       eb fe                   jmp    7c6a <spin>

00007c6c <gdt>:
        ...
    7c74:       ff                      (bad)
    7c75:       ff 00                   incl   (%eax)
    7c77:       00 00                   add    %al,(%eax)
    7c79:       9a cf 00 ff ff 00 00    lcall  $0x0,$0xffff00cf
    7c80:       00                      .byte 0x0
    7c81:       92                      xchg   %eax,%edx
    7c82:       cf                      iret
        ...

00007c84 <gdtdesc>:
    7c84:       17                      pop    %ss
    7c85:       00 6c 7c 00             add    %ch,0x0(%esp,%edi,2)
    7c89:       00 66 90                add    %ah,-0x70(%esi)

00007c8c <bootmain>:
    7c8c:       55                      push   %ebp
    7c8d:       89 e5                   mov    %esp,%ebp
    7c8f:       81 ec 14 00 00 00       sub    $0x14,%esp
    7c95:       b8 00 00 01 00          mov    $0x10000,%eax
    7c9a:       89 45 fc                mov    %eax,-0x4(%ebp)
    7c9d:       b8 00 00 00 00          mov    $0x0,%eax
    7ca2:       50                      push   %eax
    7ca3:       b8 00 10 00 00          mov    $0x1000,%eax
    7ca8:       50                      push   %eax
    7ca9:       8b 45 fc                mov    -0x4(%ebp),%eax
    7cac:       50                      push   %eax
    7cad:       e8 c4 01 00 00          call   7e76 <readseg>
    7cb2:       83 c4 0c                add    $0xc,%esp
    7cb5:       8b 45 fc                mov    -0x4(%ebp),%eax
    7cb8:       8b 00                   mov    (%eax),%eax
    7cba:       81 f8 7f 45 4c 46       cmp    $0x464c457f,%eax
    7cc0:       0f 84 05 00 00 00       je     7ccb <bootmain+0x3f>
    7cc6:       e9 c6 00 00 00          jmp    7d91 <bootmain+0x105>
    7ccb:       8b 45 fc                mov    -0x4(%ebp),%eax
    7cce:       83 c0 1c                add    $0x1c,%eax
    7cd1:       8b 00                   mov    (%eax),%eax
    7cd3:       8b 4d fc                mov    -0x4(%ebp),%ecx
    7cd6:       01 c1                   add    %eax,%ecx
    7cd8:       89 4d f8                mov    %ecx,-0x8(%ebp)
    7cdb:       8b 45 fc                mov    -0x4(%ebp),%eax
    7cde:       83 c0 2c                add    $0x2c,%eax
    7ce1:       0f b7 00                movzwl (%eax),%eax
    7ce4:       c1 e0 05                shl    $0x5,%eax
    7ce7:       8b 4d f8                mov    -0x8(%ebp),%ecx
    7cea:       01 c1                   add    %eax,%ecx
    7cec:       89 4d f4                mov    %ecx,-0xc(%ebp)
    7cef:       8b 45 f8                mov    -0x8(%ebp),%eax
    7cf2:       8b 4d f4                mov    -0xc(%ebp),%ecx
    7cf5:       39 c8                   cmp    %ecx,%eax
    7cf7:       0f 83 84 00 00 00       jae    7d81 <bootmain+0xf5>
    7cfd:       e9 0d 00 00 00          jmp    7d0f <bootmain+0x83>
    7d02:       8b 45 f8                mov    -0x8(%ebp),%eax
    7d05:       89 c1                   mov    %eax,%ecx
    7d07:       83 c0 20                add    $0x20,%eax
    7d0a:       89 45 f8                mov    %eax,-0x8(%ebp)
    7d0d:       eb e0                   jmp    7cef <bootmain+0x63>
    7d0f:       8b 45 f8                mov    -0x8(%ebp),%eax
    7d12:       83 c0 0c                add    $0xc,%eax
    7d15:       8b 00                   mov    (%eax),%eax
    7d17:       89 45 ec                mov    %eax,-0x14(%ebp)
    7d1a:       8b 45 f8                mov    -0x8(%ebp),%eax
    7d1d:       83 c0 10                add    $0x10,%eax
    7d20:       8b 4d f8                mov    -0x8(%ebp),%ecx
    7d23:       83 c1 04                add    $0x4,%ecx
    7d26:       8b 09                   mov    (%ecx),%ecx
    7d28:       51                      push   %ecx
    7d29:       8b 00                   mov    (%eax),%eax
    7d2b:       50                      push   %eax
    7d2c:       8b 45 ec                mov    -0x14(%ebp),%eax
    7d2f:       50                      push   %eax
    7d30:       e8 41 01 00 00          call   7e76 <readseg>
    7d35:       83 c4 0c                add    $0xc,%esp
    7d38:       8b 45 f8                mov    -0x8(%ebp),%eax
    7d3b:       83 c0 14                add    $0x14,%eax
    7d3e:       8b 4d f8                mov    -0x8(%ebp),%ecx
    7d41:       83 c1 10                add    $0x10,%ecx
    7d44:       8b 00                   mov    (%eax),%eax
    7d46:       8b 09                   mov    (%ecx),%ecx
    7d48:       39 c8                   cmp    %ecx,%eax
    7d4a:       0f 86 2f 00 00 00       jbe    7d7f <bootmain+0xf3>
    7d50:       8b 45 f8                mov    -0x8(%ebp),%eax
    7d53:       83 c0 10                add    $0x10,%eax
    7d56:       8b 00                   mov    (%eax),%eax
    7d58:       8b 4d ec                mov    -0x14(%ebp),%ecx
    7d5b:       01 c1                   add    %eax,%ecx
    7d5d:       8b 45 f8                mov    -0x8(%ebp),%eax
    7d60:       83 c0 14                add    $0x14,%eax
    7d63:       8b 55 f8                mov    -0x8(%ebp),%edx
    7d66:       83 c2 10                add    $0x10,%edx
    7d69:       8b 00                   mov    (%eax),%eax
    7d6b:       8b 12                   mov    (%edx),%edx
    7d6d:       29 d0                   sub    %edx,%eax
    7d6f:       50                      push   %eax
    7d70:       b8 00 00 00 00          mov    $0x0,%eax
    7d75:       50                      push   %eax
    7d76:       51                      push   %ecx
    7d77:       e8 b1 01 00 00          call   7f2d <stosb>
    7d7c:       83 c4 0c                add    $0xc,%esp
    7d7f:       eb 81                   jmp    7d02 <bootmain+0x76>
    7d81:       8b 45 fc                mov    -0x4(%ebp),%eax
    7d84:       83 c0 18                add    $0x18,%eax
    7d87:       8b 00                   mov    (%eax),%eax
    7d89:       89 45 f0                mov    %eax,-0x10(%ebp)
    7d8c:       8b 45 f0                mov    -0x10(%ebp),%eax
    7d8f:       ff d0                   call   *%eax
    7d91:       c9                      leave
    7d92:       c3                      ret

00007d93 <waitdisk>:
    7d93:       55                      push   %ebp
    7d94:       89 e5                   mov    %esp,%ebp
    7d96:       81 ec 00 00 00 00       sub    $0x0,%esp
    7d9c:       b8 f7 01 00 00          mov    $0x1f7,%eax
    7da1:       50                      push   %eax
    7da2:       e8 3c 01 00 00          call   7ee3 <inb>
    7da7:       83 c4 04                add    $0x4,%esp
    7daa:       0f b6 c0                movzbl %al,%eax
    7dad:       81 e0 c0 00 00 00       and    $0xc0,%eax
    7db3:       83 f8 40                cmp    $0x40,%eax
    7db6:       0f 84 02 00 00 00       je     7dbe <waitdisk+0x2b>
    7dbc:       eb de                   jmp    7d9c <waitdisk+0x9>
    7dbe:       c9                      leave
    7dbf:       c3                      ret

00007dc0 <readsect>:
    7dc0:       55                      push   %ebp
    7dc1:       89 e5                   mov    %esp,%ebp
    7dc3:       81 ec 00 00 00 00       sub    $0x0,%esp
    7dc9:       e8 c5 ff ff ff          call   7d93 <waitdisk>
    7dce:       b8 01 00 00 00          mov    $0x1,%eax
    7dd3:       50                      push   %eax
    7dd4:       b8 f2 01 00 00          mov    $0x1f2,%eax
    7dd9:       50                      push   %eax
    7dda:       e8 3a 01 00 00          call   7f19 <outb>
    7ddf:       83 c4 08                add    $0x8,%esp
    7de2:       0f b6 45 0c             movzbl 0xc(%ebp),%eax
    7de6:       50                      push   %eax
    7de7:       b8 f3 01 00 00          mov    $0x1f3,%eax
    7dec:       50                      push   %eax
    7ded:       e8 27 01 00 00          call   7f19 <outb>
    7df2:       83 c4 08                add    $0x8,%esp
    7df5:       8b 45 0c                mov    0xc(%ebp),%eax
    7df8:       c1 e8 08                shr    $0x8,%eax
    7dfb:       0f b6 c0                movzbl %al,%eax
    7dfe:       50                      push   %eax
    7dff:       b8 f4 01 00 00          mov    $0x1f4,%eax
    7e04:       50                      push   %eax
    7e05:       e8 0f 01 00 00          call   7f19 <outb>
    7e0a:       83 c4 08                add    $0x8,%esp
    7e0d:       8b 45 0c                mov    0xc(%ebp),%eax
    7e10:       c1 e8 10                shr    $0x10,%eax
    7e13:       0f b6 c0                movzbl %al,%eax
    7e16:       50                      push   %eax
    7e17:       b8 f5 01 00 00          mov    $0x1f5,%eax
    7e1c:       50                      push   %eax
    7e1d:       e8 f7 00 00 00          call   7f19 <outb>
    7e22:       83 c4 08                add    $0x8,%esp
    7e25:       8b 45 0c                mov    0xc(%ebp),%eax
    7e28:       c1 e8 18                shr    $0x18,%eax
    7e2b:       81 c8 e0 00 00 00       or     $0xe0,%eax
    7e31:       0f b6 c0                movzbl %al,%eax
    7e34:       50                      push   %eax
    7e35:       b8 f6 01 00 00          mov    $0x1f6,%eax
    7e3a:       50                      push   %eax
    7e3b:       e8 d9 00 00 00          call   7f19 <outb>
    7e40:       83 c4 08                add    $0x8,%esp
    7e43:       b8 20 00 00 00          mov    $0x20,%eax
    7e48:       50                      push   %eax
    7e49:       b8 f7 01 00 00          mov    $0x1f7,%eax
    7e4e:       50                      push   %eax
    7e4f:       e8 c5 00 00 00          call   7f19 <outb>
    7e54:       83 c4 08                add    $0x8,%esp
    7e57:       e8 37 ff ff ff          call   7d93 <waitdisk>
    7e5c:       b8 80 00 00 00          mov    $0x80,%eax
    7e61:       50                      push   %eax
    7e62:       8b 45 08                mov    0x8(%ebp),%eax
    7e65:       50                      push   %eax
    7e66:       b8 f0 01 00 00          mov    $0x1f0,%eax
    7e6b:       50                      push   %eax
    7e6c:       e8 89 00 00 00          call   7efa <insl>
    7e71:       83 c4 0c                add    $0xc,%esp
    7e74:       c9                      leave
    7e75:       c3                      ret

00007e76 <readseg>:
    7e76:       55                      push   %ebp
    7e77:       89 e5                   mov    %esp,%ebp
    7e79:       81 ec 04 00 00 00       sub    $0x4,%esp
    7e7f:       8b 45 0c                mov    0xc(%ebp),%eax
    7e82:       8b 4d 08                mov    0x8(%ebp),%ecx
    7e85:       01 c1                   add    %eax,%ecx
    7e87:       89 4d fc                mov    %ecx,-0x4(%ebp)
    7e8a:       8b 45 10                mov    0x10(%ebp),%eax
    7e8d:       81 e0 ff 01 00 00       and    $0x1ff,%eax
    7e93:       8b 4d 08                mov    0x8(%ebp),%ecx
    7e96:       29 c1                   sub    %eax,%ecx
    7e98:       89 4d 08                mov    %ecx,0x8(%ebp)
    7e9b:       8b 45 10                mov    0x10(%ebp),%eax
    7e9e:       c1 e8 09                shr    $0x9,%eax
    7ea1:       40                      inc    %eax
    7ea2:       89 45 10                mov    %eax,0x10(%ebp)
    7ea5:       8b 45 08                mov    0x8(%ebp),%eax
    7ea8:       8b 4d fc                mov    -0x4(%ebp),%ecx
    7eab:       39 c8                   cmp    %ecx,%eax
    7ead:       0f 83 2e 00 00 00       jae    7ee1 <readseg+0x6b>
    7eb3:       e9 17 00 00 00          jmp    7ecf <readseg+0x59>
    7eb8:       8b 45 08                mov    0x8(%ebp),%eax
    7ebb:       81 c0 00 02 00 00       add    $0x200,%eax
    7ec1:       89 45 08                mov    %eax,0x8(%ebp)
    7ec4:       8b 45 10                mov    0x10(%ebp),%eax
    7ec7:       89 c1                   mov    %eax,%ecx
    7ec9:       40                      inc    %eax
    7eca:       89 45 10                mov    %eax,0x10(%ebp)
    7ecd:       eb d6                   jmp    7ea5 <readseg+0x2f>
    7ecf:       8b 45 10                mov    0x10(%ebp),%eax
    7ed2:       50                      push   %eax
    7ed3:       8b 45 08                mov    0x8(%ebp),%eax
    7ed6:       50                      push   %eax
    7ed7:       e8 e4 fe ff ff          call   7dc0 <readsect>
    7edc:       83 c4 08                add    $0x8,%esp
    7edf:       eb d7                   jmp    7eb8 <readseg+0x42>
    7ee1:       c9                      leave
    7ee2:       c3                      ret

00007ee3 <inb>:
    7ee3:       55                      push   %ebp
    7ee4:       89 e5                   mov    %esp,%ebp
    7ee6:       81 ec 04 00 00 00       sub    $0x4,%esp
    7eec:       0f b7 55 08             movzwl 0x8(%ebp),%edx
    7ef0:       ec                      in     (%dx),%al
    7ef1:       88 45 ff                mov    %al,-0x1(%ebp)
    7ef4:       0f b6 45 ff             movzbl -0x1(%ebp),%eax
    7ef8:       c9                      leave
    7ef9:       c3                      ret

00007efa <insl>:
    7efa:       55                      push   %ebp
    7efb:       89 e5                   mov    %esp,%ebp
    7efd:       81 ec 00 00 00 00       sub    $0x0,%esp
    7f03:       57                      push   %edi
    7f04:       8b 55 08                mov    0x8(%ebp),%edx
    7f07:       8b 7d 0c                mov    0xc(%ebp),%edi
    7f0a:       8b 4d 10                mov    0x10(%ebp),%ecx
    7f0d:       fc                      cld
    7f0e:       f3 6d                   rep insl (%dx),%es:(%edi)
    7f10:       89 7d 0c                mov    %edi,0xc(%ebp)
    7f13:       89 4d 10                mov    %ecx,0x10(%ebp)
    7f16:       5f                      pop    %edi
    7f17:       c9                      leave
    7f18:       c3                      ret

00007f19 <outb>:
    7f19:       55                      push   %ebp
    7f1a:       89 e5                   mov    %esp,%ebp
    7f1c:       81 ec 00 00 00 00       sub    $0x0,%esp
    7f22:       0f b6 45 0c             movzbl 0xc(%ebp),%eax
    7f26:       0f b7 55 08             movzwl 0x8(%ebp),%edx
    7f2a:       ee                      out    %al,(%dx)
    7f2b:       c9                      leave
    7f2c:       c3                      ret

00007f2d <stosb>:
    7f2d:       55                      push   %ebp
    7f2e:       89 e5                   mov    %esp,%ebp
    7f30:       81 ec 00 00 00 00       sub    $0x0,%esp
    7f36:       57                      push   %edi
    7f37:       8b 7d 08                mov    0x8(%ebp),%edi
    7f3a:       8b 4d 10                mov    0x10(%ebp),%ecx
    7f3d:       8b 45 0c                mov    0xc(%ebp),%eax
    7f40:       fc                      cld
    7f41:       f3 aa                   rep stos %al,%es:(%edi)
    7f43:       89 7d 08                mov    %edi,0x8(%ebp)
    7f46:       89 4d 10                mov    %ecx,0x10(%ebp)
    7f49:       5f                      pop    %edi
    7f4a:       c9                      leave
    7f4b:       c3                      ret
```


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

_Last updated: December 4, 2025_
