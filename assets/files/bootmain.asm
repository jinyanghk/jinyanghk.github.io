
bootmain.o:     file format elf32-i386


Disassembly of section .text:

00000000 <waitdisk>:
  entry();
}

void
waitdisk(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
   3:	ba f7 01 00 00       	mov    $0x1f7,%edx
   8:	ec                   	in     (%dx),%al
  // Wait for disk ready.
  while((inb(0x1F7) & 0xC0) != 0x40)
   9:	83 e0 c0             	and    $0xffffffc0,%eax
   c:	3c 40                	cmp    $0x40,%al
   e:	75 f8                	jne    8 <waitdisk+0x8>
    ;
}
  10:	5d                   	pop    %ebp
  11:	c3                   	ret    

00000012 <readsect>:

// Read a single sector at offset into dst.
void
readsect(void *dst, uint offset)
{
  12:	55                   	push   %ebp
  13:	89 e5                	mov    %esp,%ebp
  15:	57                   	push   %edi
  16:	53                   	push   %ebx
  17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  // Issue command.
  waitdisk();
  1a:	e8 fc ff ff ff       	call   1b <readsect+0x9>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
  1f:	b8 01 00 00 00       	mov    $0x1,%eax
  24:	ba f2 01 00 00       	mov    $0x1f2,%edx
  29:	ee                   	out    %al,(%dx)
  2a:	ba f3 01 00 00       	mov    $0x1f3,%edx
  2f:	89 d8                	mov    %ebx,%eax
  31:	ee                   	out    %al,(%dx)
  outb(0x1F2, 1);   // count = 1
  outb(0x1F3, offset);
  outb(0x1F4, offset >> 8);
  32:	89 d8                	mov    %ebx,%eax
  34:	c1 e8 08             	shr    $0x8,%eax
  37:	ba f4 01 00 00       	mov    $0x1f4,%edx
  3c:	ee                   	out    %al,(%dx)
  outb(0x1F5, offset >> 16);
  3d:	89 d8                	mov    %ebx,%eax
  3f:	c1 e8 10             	shr    $0x10,%eax
  42:	ba f5 01 00 00       	mov    $0x1f5,%edx
  47:	ee                   	out    %al,(%dx)
  outb(0x1F6, (offset >> 24) | 0xE0);
  48:	89 d8                	mov    %ebx,%eax
  4a:	c1 e8 18             	shr    $0x18,%eax
  4d:	83 c8 e0             	or     $0xffffffe0,%eax
  50:	ba f6 01 00 00       	mov    $0x1f6,%edx
  55:	ee                   	out    %al,(%dx)
  56:	b8 20 00 00 00       	mov    $0x20,%eax
  5b:	ba f7 01 00 00       	mov    $0x1f7,%edx
  60:	ee                   	out    %al,(%dx)
  outb(0x1F7, 0x20);  // cmd 0x20 - read sectors

  // Read data.
  waitdisk();
  61:	e8 fc ff ff ff       	call   62 <readsect+0x50>
  asm volatile("cld; rep insl" :
  66:	8b 7d 08             	mov    0x8(%ebp),%edi
  69:	b9 80 00 00 00       	mov    $0x80,%ecx
  6e:	ba f0 01 00 00       	mov    $0x1f0,%edx
  73:	fc                   	cld    
  74:	f3 6d                	rep insl (%dx),%es:(%edi)
  insl(0x1F0, dst, SECTSIZE/4);
}
  76:	5b                   	pop    %ebx
  77:	5f                   	pop    %edi
  78:	5d                   	pop    %ebp
  79:	c3                   	ret    

0000007a <readseg>:

// Read 'count' bytes at 'offset' from kernel into physical address 'pa'.
// Might copy more than asked.
void
readseg(uchar* pa, uint count, uint offset)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  7d:	57                   	push   %edi
  7e:	56                   	push   %esi
  7f:	53                   	push   %ebx
  80:	8b 5d 08             	mov    0x8(%ebp),%ebx
  83:	8b 75 10             	mov    0x10(%ebp),%esi
  uchar* epa;

  epa = pa + count;
  86:	89 df                	mov    %ebx,%edi
  88:	03 7d 0c             	add    0xc(%ebp),%edi

  // Round down to sector boundary.
  pa -= offset % SECTSIZE;
  8b:	89 f0                	mov    %esi,%eax
  8d:	25 ff 01 00 00       	and    $0x1ff,%eax
  92:	29 c3                	sub    %eax,%ebx

  // Translate from bytes to sectors; kernel starts at sector 1.
  offset = (offset / SECTSIZE) + 1;
  94:	c1 ee 09             	shr    $0x9,%esi
  97:	83 c6 01             	add    $0x1,%esi

  // If this is too slow, we could read lots of sectors at a time.
  // We'd write more to memory than asked, but it doesn't matter --
  // we load in increasing order.
  for(; pa < epa; pa += SECTSIZE, offset++)
  9a:	39 df                	cmp    %ebx,%edi
  9c:	76 17                	jbe    b5 <readseg+0x3b>
    readsect(pa, offset);
  9e:	56                   	push   %esi
  9f:	53                   	push   %ebx
  a0:	e8 fc ff ff ff       	call   a1 <readseg+0x27>
  for(; pa < epa; pa += SECTSIZE, offset++)
  a5:	81 c3 00 02 00 00    	add    $0x200,%ebx
  ab:	83 c6 01             	add    $0x1,%esi
  ae:	83 c4 08             	add    $0x8,%esp
  b1:	39 df                	cmp    %ebx,%edi
  b3:	77 e9                	ja     9e <readseg+0x24>
}
  b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  b8:	5b                   	pop    %ebx
  b9:	5e                   	pop    %esi
  ba:	5f                   	pop    %edi
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <bootmain>:
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	57                   	push   %edi
  c1:	56                   	push   %esi
  c2:	53                   	push   %ebx
  c3:	83 ec 0c             	sub    $0xc,%esp
  readseg((uchar*)elf, 4096, 0);
  c6:	6a 00                	push   $0x0
  c8:	68 00 10 00 00       	push   $0x1000
  cd:	68 00 00 01 00       	push   $0x10000
  d2:	e8 fc ff ff ff       	call   d3 <bootmain+0x16>
  if(elf->magic != ELF_MAGIC)
  d7:	83 c4 0c             	add    $0xc,%esp
  da:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
  e1:	45 4c 46 
  e4:	74 08                	je     ee <bootmain+0x31>
}
  e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  e9:	5b                   	pop    %ebx
  ea:	5e                   	pop    %esi
  eb:	5f                   	pop    %edi
  ec:	5d                   	pop    %ebp
  ed:	c3                   	ret    
  ph = (struct proghdr*)((uchar*)elf + elf->phoff);
  ee:	a1 1c 00 01 00       	mov    0x1001c,%eax
  f3:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
  eph = ph + elf->phnum;
  f9:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
 100:	c1 e6 05             	shl    $0x5,%esi
 103:	01 de                	add    %ebx,%esi
  for(; ph < eph; ph++){
 105:	39 f3                	cmp    %esi,%ebx
 107:	72 0f                	jb     118 <bootmain+0x5b>
  entry();
 109:	ff 15 18 00 01 00    	call   *0x10018
 10f:	eb d5                	jmp    e6 <bootmain+0x29>
  for(; ph < eph; ph++){
 111:	83 c3 20             	add    $0x20,%ebx
 114:	39 de                	cmp    %ebx,%esi
 116:	76 f1                	jbe    109 <bootmain+0x4c>
    pa = (uchar*)ph->paddr;
 118:	8b 7b 0c             	mov    0xc(%ebx),%edi
    readseg(pa, ph->filesz, ph->off);
 11b:	ff 73 04             	pushl  0x4(%ebx)
 11e:	ff 73 10             	pushl  0x10(%ebx)
 121:	57                   	push   %edi
 122:	e8 fc ff ff ff       	call   123 <bootmain+0x66>
    if(ph->memsz > ph->filesz)
 127:	8b 4b 14             	mov    0x14(%ebx),%ecx
 12a:	8b 43 10             	mov    0x10(%ebx),%eax
 12d:	83 c4 0c             	add    $0xc,%esp
 130:	39 c1                	cmp    %eax,%ecx
 132:	76 dd                	jbe    111 <bootmain+0x54>
      stosb(pa + ph->filesz, 0, ph->memsz - ph->filesz);
 134:	01 c7                	add    %eax,%edi
 136:	29 c1                	sub    %eax,%ecx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 138:	b8 00 00 00 00       	mov    $0x0,%eax
 13d:	fc                   	cld    
 13e:	f3 aa                	rep stos %al,%es:(%edi)
 140:	eb cf                	jmp    111 <bootmain+0x54>
