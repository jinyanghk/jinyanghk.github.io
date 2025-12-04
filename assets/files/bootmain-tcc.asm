
bootmain-tcc.o:     file format elf32-i386


Disassembly of section .text:

00000000 <bootmain>:
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	81 ec 14 00 00 00    	sub    $0x14,%esp
   9:	b8 00 00 01 00       	mov    $0x10000,%eax
   e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  11:	b8 00 00 00 00       	mov    $0x0,%eax
  16:	50                   	push   %eax
  17:	b8 00 10 00 00       	mov    $0x1000,%eax
  1c:	50                   	push   %eax
  1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  20:	50                   	push   %eax
  21:	e8 fc ff ff ff       	call   22 <bootmain+0x22>
  26:	83 c4 0c             	add    $0xc,%esp
  29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  2c:	8b 00                	mov    (%eax),%eax
  2e:	81 f8 7f 45 4c 46    	cmp    $0x464c457f,%eax
  34:	0f 84 05 00 00 00    	je     3f <bootmain+0x3f>
  3a:	e9 c6 00 00 00       	jmp    105 <bootmain+0x105>
  3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  42:	83 c0 1c             	add    $0x1c,%eax
  45:	8b 00                	mov    (%eax),%eax
  47:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  4a:	01 c1                	add    %eax,%ecx
  4c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
  4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  52:	83 c0 2c             	add    $0x2c,%eax
  55:	0f b7 00             	movzwl (%eax),%eax
  58:	c1 e0 05             	shl    $0x5,%eax
  5b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  5e:	01 c1                	add    %eax,%ecx
  60:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  66:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  69:	39 c8                	cmp    %ecx,%eax
  6b:	0f 83 84 00 00 00    	jae    f5 <bootmain+0xf5>
  71:	e9 0d 00 00 00       	jmp    83 <bootmain+0x83>
  76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  79:	89 c1                	mov    %eax,%ecx
  7b:	83 c0 20             	add    $0x20,%eax
  7e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  81:	eb e0                	jmp    63 <bootmain+0x63>
  83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  86:	83 c0 0c             	add    $0xc,%eax
  89:	8b 00                	mov    (%eax),%eax
  8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  91:	83 c0 10             	add    $0x10,%eax
  94:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  97:	83 c1 04             	add    $0x4,%ecx
  9a:	8b 09                	mov    (%ecx),%ecx
  9c:	51                   	push   %ecx
  9d:	8b 00                	mov    (%eax),%eax
  9f:	50                   	push   %eax
  a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  a3:	50                   	push   %eax
  a4:	e8 fc ff ff ff       	call   a5 <bootmain+0xa5>
  a9:	83 c4 0c             	add    $0xc,%esp
  ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  af:	83 c0 14             	add    $0x14,%eax
  b2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  b5:	83 c1 10             	add    $0x10,%ecx
  b8:	8b 00                	mov    (%eax),%eax
  ba:	8b 09                	mov    (%ecx),%ecx
  bc:	39 c8                	cmp    %ecx,%eax
  be:	0f 86 2f 00 00 00    	jbe    f3 <bootmain+0xf3>
  c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  c7:	83 c0 10             	add    $0x10,%eax
  ca:	8b 00                	mov    (%eax),%eax
  cc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  cf:	01 c1                	add    %eax,%ecx
  d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  d4:	83 c0 14             	add    $0x14,%eax
  d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  da:	83 c2 10             	add    $0x10,%edx
  dd:	8b 00                	mov    (%eax),%eax
  df:	8b 12                	mov    (%edx),%edx
  e1:	29 d0                	sub    %edx,%eax
  e3:	50                   	push   %eax
  e4:	b8 00 00 00 00       	mov    $0x0,%eax
  e9:	50                   	push   %eax
  ea:	51                   	push   %ecx
  eb:	e8 fc ff ff ff       	call   ec <bootmain+0xec>
  f0:	83 c4 0c             	add    $0xc,%esp
  f3:	eb 81                	jmp    76 <bootmain+0x76>
  f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  f8:	83 c0 18             	add    $0x18,%eax
  fb:	8b 00                	mov    (%eax),%eax
  fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 100:	8b 45 f0             	mov    -0x10(%ebp),%eax
 103:	ff d0                	call   *%eax
 105:	c9                   	leave  
 106:	c3                   	ret    

00000107 <waitdisk>:
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	81 ec 00 00 00 00    	sub    $0x0,%esp
 110:	b8 f7 01 00 00       	mov    $0x1f7,%eax
 115:	50                   	push   %eax
 116:	e8 fc ff ff ff       	call   117 <waitdisk+0x10>
 11b:	83 c4 04             	add    $0x4,%esp
 11e:	0f b6 c0             	movzbl %al,%eax
 121:	81 e0 c0 00 00 00    	and    $0xc0,%eax
 127:	83 f8 40             	cmp    $0x40,%eax
 12a:	0f 84 02 00 00 00    	je     132 <waitdisk+0x2b>
 130:	eb de                	jmp    110 <waitdisk+0x9>
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <readsect>:
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	81 ec 00 00 00 00    	sub    $0x0,%esp
 13d:	e8 fc ff ff ff       	call   13e <readsect+0xa>
 142:	b8 01 00 00 00       	mov    $0x1,%eax
 147:	50                   	push   %eax
 148:	b8 f2 01 00 00       	mov    $0x1f2,%eax
 14d:	50                   	push   %eax
 14e:	e8 fc ff ff ff       	call   14f <readsect+0x1b>
 153:	83 c4 08             	add    $0x8,%esp
 156:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
 15a:	50                   	push   %eax
 15b:	b8 f3 01 00 00       	mov    $0x1f3,%eax
 160:	50                   	push   %eax
 161:	e8 fc ff ff ff       	call   162 <readsect+0x2e>
 166:	83 c4 08             	add    $0x8,%esp
 169:	8b 45 0c             	mov    0xc(%ebp),%eax
 16c:	c1 e8 08             	shr    $0x8,%eax
 16f:	0f b6 c0             	movzbl %al,%eax
 172:	50                   	push   %eax
 173:	b8 f4 01 00 00       	mov    $0x1f4,%eax
 178:	50                   	push   %eax
 179:	e8 fc ff ff ff       	call   17a <readsect+0x46>
 17e:	83 c4 08             	add    $0x8,%esp
 181:	8b 45 0c             	mov    0xc(%ebp),%eax
 184:	c1 e8 10             	shr    $0x10,%eax
 187:	0f b6 c0             	movzbl %al,%eax
 18a:	50                   	push   %eax
 18b:	b8 f5 01 00 00       	mov    $0x1f5,%eax
 190:	50                   	push   %eax
 191:	e8 fc ff ff ff       	call   192 <readsect+0x5e>
 196:	83 c4 08             	add    $0x8,%esp
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	c1 e8 18             	shr    $0x18,%eax
 19f:	81 c8 e0 00 00 00    	or     $0xe0,%eax
 1a5:	0f b6 c0             	movzbl %al,%eax
 1a8:	50                   	push   %eax
 1a9:	b8 f6 01 00 00       	mov    $0x1f6,%eax
 1ae:	50                   	push   %eax
 1af:	e8 fc ff ff ff       	call   1b0 <readsect+0x7c>
 1b4:	83 c4 08             	add    $0x8,%esp
 1b7:	b8 20 00 00 00       	mov    $0x20,%eax
 1bc:	50                   	push   %eax
 1bd:	b8 f7 01 00 00       	mov    $0x1f7,%eax
 1c2:	50                   	push   %eax
 1c3:	e8 fc ff ff ff       	call   1c4 <readsect+0x90>
 1c8:	83 c4 08             	add    $0x8,%esp
 1cb:	e8 fc ff ff ff       	call   1cc <readsect+0x98>
 1d0:	b8 80 00 00 00       	mov    $0x80,%eax
 1d5:	50                   	push   %eax
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
 1d9:	50                   	push   %eax
 1da:	b8 f0 01 00 00       	mov    $0x1f0,%eax
 1df:	50                   	push   %eax
 1e0:	e8 fc ff ff ff       	call   1e1 <readsect+0xad>
 1e5:	83 c4 0c             	add    $0xc,%esp
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <readseg>:
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	81 ec 04 00 00 00    	sub    $0x4,%esp
 1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f9:	01 c1                	add    %eax,%ecx
 1fb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 1fe:	8b 45 10             	mov    0x10(%ebp),%eax
 201:	81 e0 ff 01 00 00    	and    $0x1ff,%eax
 207:	8b 4d 08             	mov    0x8(%ebp),%ecx
 20a:	29 c1                	sub    %eax,%ecx
 20c:	89 4d 08             	mov    %ecx,0x8(%ebp)
 20f:	8b 45 10             	mov    0x10(%ebp),%eax
 212:	c1 e8 09             	shr    $0x9,%eax
 215:	40                   	inc    %eax
 216:	89 45 10             	mov    %eax,0x10(%ebp)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
 21f:	39 c8                	cmp    %ecx,%eax
 221:	0f 83 2e 00 00 00    	jae    255 <readseg+0x6b>
 227:	e9 17 00 00 00       	jmp    243 <readseg+0x59>
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	81 c0 00 02 00 00    	add    $0x200,%eax
 235:	89 45 08             	mov    %eax,0x8(%ebp)
 238:	8b 45 10             	mov    0x10(%ebp),%eax
 23b:	89 c1                	mov    %eax,%ecx
 23d:	40                   	inc    %eax
 23e:	89 45 10             	mov    %eax,0x10(%ebp)
 241:	eb d6                	jmp    219 <readseg+0x2f>
 243:	8b 45 10             	mov    0x10(%ebp),%eax
 246:	50                   	push   %eax
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	50                   	push   %eax
 24b:	e8 fc ff ff ff       	call   24c <readseg+0x62>
 250:	83 c4 08             	add    $0x8,%esp
 253:	eb d7                	jmp    22c <readseg+0x42>
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <inb>:
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	81 ec 04 00 00 00    	sub    $0x4,%esp
 260:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
 264:	ec                   	in     (%dx),%al
 265:	88 45 ff             	mov    %al,-0x1(%ebp)
 268:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <insl>:
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	81 ec 00 00 00 00    	sub    $0x0,%esp
 277:	57                   	push   %edi
 278:	8b 55 08             	mov    0x8(%ebp),%edx
 27b:	8b 7d 0c             	mov    0xc(%ebp),%edi
 27e:	8b 4d 10             	mov    0x10(%ebp),%ecx
 281:	fc                   	cld    
 282:	f3 6d                	rep insl (%dx),%es:(%edi)
 284:	89 7d 0c             	mov    %edi,0xc(%ebp)
 287:	89 4d 10             	mov    %ecx,0x10(%ebp)
 28a:	5f                   	pop    %edi
 28b:	c9                   	leave  
 28c:	c3                   	ret    

0000028d <outb>:
 28d:	55                   	push   %ebp
 28e:	89 e5                	mov    %esp,%ebp
 290:	81 ec 00 00 00 00    	sub    $0x0,%esp
 296:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
 29a:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
 29e:	ee                   	out    %al,(%dx)
 29f:	c9                   	leave  
 2a0:	c3                   	ret    

000002a1 <stosb>:
 2a1:	55                   	push   %ebp
 2a2:	89 e5                	mov    %esp,%ebp
 2a4:	81 ec 00 00 00 00    	sub    $0x0,%esp
 2aa:	57                   	push   %edi
 2ab:	8b 7d 08             	mov    0x8(%ebp),%edi
 2ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b4:	fc                   	cld    
 2b5:	f3 aa                	rep stos %al,%es:(%edi)
 2b7:	89 7d 08             	mov    %edi,0x8(%ebp)
 2ba:	89 4d 10             	mov    %ecx,0x10(%ebp)
 2bd:	5f                   	pop    %edi
 2be:	c9                   	leave  
 2bf:	c3                   	ret    
