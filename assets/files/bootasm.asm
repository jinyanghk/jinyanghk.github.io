
bootasm.o:     file format elf32-i386


Disassembly of section .text:

00000000 <start>:
# with %cs=0 %ip=7c00.

.code16                       # Assemble for 16-bit mode
.globl start
start:
  cli                         # BIOS enabled interrupts; disable
   0:	fa                   	cli    

  # Zero data segment registers DS, ES, and SS.
  xorw    %ax,%ax             # Set %ax to zero
   1:	31 c0                	xor    %eax,%eax
  movw    %ax,%ds             # -> Data Segment
   3:	8e d8                	mov    %eax,%ds
  movw    %ax,%es             # -> Extra Segment
   5:	8e c0                	mov    %eax,%es
  movw    %ax,%ss             # -> Stack Segment
   7:	8e d0                	mov    %eax,%ss

00000009 <seta20.1>:

  # Physical address line A20 is tied to zero so that the first PCs 
  # with 2 MB would run software that assumed 1 MB.  Undo that.
seta20.1:
  inb     $0x64,%al               # Wait for not busy
   9:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
   b:	a8 02                	test   $0x2,%al
  jnz     seta20.1
   d:	75 fa                	jne    9 <seta20.1>

  movb    $0xd1,%al               # 0xd1 -> port 0x64
   f:	b0 d1                	mov    $0xd1,%al
  outb    %al,$0x64
  11:	e6 64                	out    %al,$0x64

00000013 <seta20.2>:

seta20.2:
  inb     $0x64,%al               # Wait for not busy
  13:	e4 64                	in     $0x64,%al
  testb   $0x2,%al
  15:	a8 02                	test   $0x2,%al
  jnz     seta20.2
  17:	75 fa                	jne    13 <seta20.2>

  movb    $0xdf,%al               # 0xdf -> port 0x60
  19:	b0 df                	mov    $0xdf,%al
  outb    %al,$0x60
  1b:	e6 60                	out    %al,$0x60

  # Switch from real to protected mode.  Use a bootstrap GDT that makes
  # virtual addresses map directly to physical addresses so that the
  # effective memory map doesn't change during the transition.
  lgdt    gdtdesc
  1d:	0f 01 16             	lgdtl  (%esi)
  20:	78 00                	js     22 <seta20.2+0xf>
  movl    %cr0, %eax
  22:	0f 20 c0             	mov    %cr0,%eax
  orl     $CR0_PE, %eax
  25:	66 83 c8 01          	or     $0x1,%ax
  movl    %eax, %cr0
  29:	0f 22 c0             	mov    %eax,%cr0

//PAGEBREAK!
  # Complete the transition to 32-bit protected mode by using a long jmp
  # to reload %cs and %eip.  The segment descriptors are set up with no
  # translation, so that the mapping is still the identity mapping.
  ljmp    $(SEG_KCODE<<3), $start32
  2c:	ea                   	.byte 0xea
  2d:	31 00                	xor    %eax,(%eax)
  2f:	08 00                	or     %al,(%eax)

00000031 <start32>:

.code32  # Tell assembler to generate 32-bit code now.
start32:
  # Set up the protected-mode data segment registers
  movw    $(SEG_KDATA<<3), %ax    # Our data segment selector
  31:	66 b8 10 00          	mov    $0x10,%ax
  movw    %ax, %ds                # -> DS: Data Segment
  35:	8e d8                	mov    %eax,%ds
  movw    %ax, %es                # -> ES: Extra Segment
  37:	8e c0                	mov    %eax,%es
  movw    %ax, %ss                # -> SS: Stack Segment
  39:	8e d0                	mov    %eax,%ss
  movw    $0, %ax                 # Zero segments not ready for use
  3b:	66 b8 00 00          	mov    $0x0,%ax
  movw    %ax, %fs                # -> FS
  3f:	8e e0                	mov    %eax,%fs
  movw    %ax, %gs                # -> GS
  41:	8e e8                	mov    %eax,%gs

  # Set up the stack pointer and call into C.
  movl    $start, %esp
  43:	bc 00 00 00 00       	mov    $0x0,%esp
  call    bootmain
  48:	e8 fc ff ff ff       	call   49 <start32+0x18>

  # If bootmain returns (it shouldn't), trigger a Bochs
  # breakpoint if running under Bochs, then loop.
  movw    $0x8a00, %ax            # 0x8a00 -> port 0x8a00
  4d:	66 b8 00 8a          	mov    $0x8a00,%ax
  movw    %ax, %dx
  51:	66 89 c2             	mov    %ax,%dx
  outw    %ax, %dx
  54:	66 ef                	out    %ax,(%dx)
  movw    $0x8ae0, %ax            # 0x8ae0 -> port 0x8a00
  56:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  outw    %ax, %dx
  5a:	66 ef                	out    %ax,(%dx)

0000005c <spin>:
spin:
  jmp     spin
  5c:	eb fe                	jmp    5c <spin>
  5e:	66 90                	xchg   %ax,%ax

00000060 <gdt>:
	...
  68:	ff                   	(bad)  
  69:	ff 00                	incl   (%eax)
  6b:	00 00                	add    %al,(%eax)
  6d:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
  74:	00                   	.byte 0x0
  75:	92                   	xchg   %eax,%edx
  76:	cf                   	iret   
	...

00000078 <gdtdesc>:
  78:	17                   	pop    %ss
  79:	00 60 00             	add    %ah,0x0(%eax)
	...
