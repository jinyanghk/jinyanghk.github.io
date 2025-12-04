
bootasm-tcc.o:     file format elf32-i386


Disassembly of section .text:

00000000 <start>:
   0:	fa                   	cli    
   1:	66 31 c0             	xor    %ax,%ax
   4:	66 8e d8             	mov    %ax,%ds
   7:	66 8e c0             	mov    %ax,%es
   a:	66 8e d0             	mov    %ax,%ss

0000000d <seta20.1>:
   d:	e4 64                	in     $0x64,%al
   f:	a8 02                	test   $0x2,%al
  11:	75 fa                	jne    d <seta20.1>
  13:	b0 d1                	mov    $0xd1,%al
  15:	e6 64                	out    %al,$0x64

00000017 <seta20.2>:
  17:	e4 64                	in     $0x64,%al
  19:	a8 02                	test   $0x2,%al
  1b:	75 fa                	jne    17 <seta20.2>
  1d:	b0 df                	mov    $0xdf,%al
  1f:	e6 60                	out    %al,$0x60
  21:	0f 01 15 00 00 00 00 	lgdtl  0x0
  28:	0f 20 c0             	mov    %cr0,%eax
  2b:	0d 01 00 00 00       	or     $0x1,%eax
  30:	0f 22 c0             	mov    %eax,%cr0
  33:	ea 00 00 00 00 08 00 	ljmp   $0x8,$0x0

0000003a <start32>:
  3a:	66 b8 10 00          	mov    $0x10,%ax
  3e:	66 8e d8             	mov    %ax,%ds
  41:	66 8e c0             	mov    %ax,%es
  44:	66 8e d0             	mov    %ax,%ss
  47:	66 b8 00 00          	mov    $0x0,%ax
  4b:	66 8e e0             	mov    %ax,%fs
  4e:	66 8e e8             	mov    %ax,%gs
  51:	bc 00 00 00 00       	mov    $0x0,%esp
  56:	e8 fc ff ff ff       	call   57 <start32+0x1d>
  5b:	66 b8 00 8a          	mov    $0x8a00,%ax
  5f:	66 89 c2             	mov    %ax,%dx
  62:	66 ef                	out    %ax,(%dx)
  64:	66 b8 e0 8a          	mov    $0x8ae0,%ax
  68:	66 ef                	out    %ax,(%dx)

0000006a <spin>:
  6a:	eb fe                	jmp    6a <spin>

0000006c <gdt>:
	...
  74:	ff                   	(bad)  
  75:	ff 00                	incl   (%eax)
  77:	00 00                	add    %al,(%eax)
  79:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
  80:	00                   	.byte 0x0
  81:	92                   	xchg   %eax,%edx
  82:	cf                   	iret   
	...

00000084 <gdtdesc>:
  84:	17                   	pop    %ss
  85:	00 00                	add    %al,(%eax)
  87:	00 00                	add    %al,(%eax)
	...
