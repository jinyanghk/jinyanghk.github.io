
bootblock-tcc.o:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
    7c00:	fa                   	cli    
    7c01:	66 31 c0             	xor    %ax,%ax
    7c04:	66 8e d8             	mov    %ax,%ds
    7c07:	66 8e c0             	mov    %ax,%es
    7c0a:	66 8e d0             	mov    %ax,%ss

00007c0d <seta20.1>:
    7c0d:	e4 64                	in     $0x64,%al
    7c0f:	a8 02                	test   $0x2,%al
    7c11:	75 fa                	jne    7c0d <seta20.1>
    7c13:	b0 d1                	mov    $0xd1,%al
    7c15:	e6 64                	out    %al,$0x64

00007c17 <seta20.2>:
    7c17:	e4 64                	in     $0x64,%al
    7c19:	a8 02                	test   $0x2,%al
    7c1b:	75 fa                	jne    7c17 <seta20.2>
    7c1d:	b0 df                	mov    $0xdf,%al
    7c1f:	e6 60                	out    %al,$0x60
    7c21:	0f 01 15 84 7c 00 00 	lgdtl  0x7c84
    7c28:	0f 20 c0             	mov    %cr0,%eax
    7c2b:	0d 01 00 00 00       	or     $0x1,%eax
    7c30:	0f 22 c0             	mov    %eax,%cr0
    7c33:	ea 3a 7c 00 00 08 00 	ljmp   $0x8,$0x7c3a

00007c3a <start32>:
    7c3a:	66 b8 10 00          	mov    $0x10,%ax
    7c3e:	66 8e d8             	mov    %ax,%ds
    7c41:	66 8e c0             	mov    %ax,%es
    7c44:	66 8e d0             	mov    %ax,%ss
    7c47:	66 b8 00 00          	mov    $0x0,%ax
    7c4b:	66 8e e0             	mov    %ax,%fs
    7c4e:	66 8e e8             	mov    %ax,%gs
    7c51:	bc 00 7c 00 00       	mov    $0x7c00,%esp
    7c56:	e8 31 00 00 00       	call   7c8c <bootmain>
    7c5b:	66 b8 00 8a          	mov    $0x8a00,%ax
    7c5f:	66 89 c2             	mov    %ax,%dx
    7c62:	66 ef                	out    %ax,(%dx)
    7c64:	66 b8 e0 8a          	mov    $0x8ae0,%ax
    7c68:	66 ef                	out    %ax,(%dx)

00007c6a <spin>:
    7c6a:	eb fe                	jmp    7c6a <spin>

00007c6c <gdt>:
	...
    7c74:	ff                   	(bad)  
    7c75:	ff 00                	incl   (%eax)
    7c77:	00 00                	add    %al,(%eax)
    7c79:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c80:	00                   	.byte 0x0
    7c81:	92                   	xchg   %eax,%edx
    7c82:	cf                   	iret   
	...

00007c84 <gdtdesc>:
    7c84:	17                   	pop    %ss
    7c85:	00 6c 7c 00          	add    %ch,0x0(%esp,%edi,2)
    7c89:	00 66 90             	add    %ah,-0x70(%esi)

00007c8c <bootmain>:
    7c8c:	55                   	push   %ebp
    7c8d:	89 e5                	mov    %esp,%ebp
    7c8f:	81 ec 14 00 00 00    	sub    $0x14,%esp
    7c95:	b8 00 00 01 00       	mov    $0x10000,%eax
    7c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    7c9d:	b8 00 00 00 00       	mov    $0x0,%eax
    7ca2:	50                   	push   %eax
    7ca3:	b8 00 10 00 00       	mov    $0x1000,%eax
    7ca8:	50                   	push   %eax
    7ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    7cac:	50                   	push   %eax
    7cad:	e8 c4 01 00 00       	call   7e76 <readseg>
    7cb2:	83 c4 0c             	add    $0xc,%esp
    7cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    7cb8:	8b 00                	mov    (%eax),%eax
    7cba:	81 f8 7f 45 4c 46    	cmp    $0x464c457f,%eax
    7cc0:	0f 84 05 00 00 00    	je     7ccb <bootmain+0x3f>
    7cc6:	e9 c6 00 00 00       	jmp    7d91 <bootmain+0x105>
    7ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    7cce:	83 c0 1c             	add    $0x1c,%eax
    7cd1:	8b 00                	mov    (%eax),%eax
    7cd3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
    7cd6:	01 c1                	add    %eax,%ecx
    7cd8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    7cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    7cde:	83 c0 2c             	add    $0x2c,%eax
    7ce1:	0f b7 00             	movzwl (%eax),%eax
    7ce4:	c1 e0 05             	shl    $0x5,%eax
    7ce7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    7cea:	01 c1                	add    %eax,%ecx
    7cec:	89 4d f4             	mov    %ecx,-0xc(%ebp)
    7cef:	8b 45 f8             	mov    -0x8(%ebp),%eax
    7cf2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    7cf5:	39 c8                	cmp    %ecx,%eax
    7cf7:	0f 83 84 00 00 00    	jae    7d81 <bootmain+0xf5>
    7cfd:	e9 0d 00 00 00       	jmp    7d0f <bootmain+0x83>
    7d02:	8b 45 f8             	mov    -0x8(%ebp),%eax
    7d05:	89 c1                	mov    %eax,%ecx
    7d07:	83 c0 20             	add    $0x20,%eax
    7d0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    7d0d:	eb e0                	jmp    7cef <bootmain+0x63>
    7d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    7d12:	83 c0 0c             	add    $0xc,%eax
    7d15:	8b 00                	mov    (%eax),%eax
    7d17:	89 45 ec             	mov    %eax,-0x14(%ebp)
    7d1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    7d1d:	83 c0 10             	add    $0x10,%eax
    7d20:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    7d23:	83 c1 04             	add    $0x4,%ecx
    7d26:	8b 09                	mov    (%ecx),%ecx
    7d28:	51                   	push   %ecx
    7d29:	8b 00                	mov    (%eax),%eax
    7d2b:	50                   	push   %eax
    7d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    7d2f:	50                   	push   %eax
    7d30:	e8 41 01 00 00       	call   7e76 <readseg>
    7d35:	83 c4 0c             	add    $0xc,%esp
    7d38:	8b 45 f8             	mov    -0x8(%ebp),%eax
    7d3b:	83 c0 14             	add    $0x14,%eax
    7d3e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    7d41:	83 c1 10             	add    $0x10,%ecx
    7d44:	8b 00                	mov    (%eax),%eax
    7d46:	8b 09                	mov    (%ecx),%ecx
    7d48:	39 c8                	cmp    %ecx,%eax
    7d4a:	0f 86 2f 00 00 00    	jbe    7d7f <bootmain+0xf3>
    7d50:	8b 45 f8             	mov    -0x8(%ebp),%eax
    7d53:	83 c0 10             	add    $0x10,%eax
    7d56:	8b 00                	mov    (%eax),%eax
    7d58:	8b 4d ec             	mov    -0x14(%ebp),%ecx
    7d5b:	01 c1                	add    %eax,%ecx
    7d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    7d60:	83 c0 14             	add    $0x14,%eax
    7d63:	8b 55 f8             	mov    -0x8(%ebp),%edx
    7d66:	83 c2 10             	add    $0x10,%edx
    7d69:	8b 00                	mov    (%eax),%eax
    7d6b:	8b 12                	mov    (%edx),%edx
    7d6d:	29 d0                	sub    %edx,%eax
    7d6f:	50                   	push   %eax
    7d70:	b8 00 00 00 00       	mov    $0x0,%eax
    7d75:	50                   	push   %eax
    7d76:	51                   	push   %ecx
    7d77:	e8 b1 01 00 00       	call   7f2d <stosb>
    7d7c:	83 c4 0c             	add    $0xc,%esp
    7d7f:	eb 81                	jmp    7d02 <bootmain+0x76>
    7d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
    7d84:	83 c0 18             	add    $0x18,%eax
    7d87:	8b 00                	mov    (%eax),%eax
    7d89:	89 45 f0             	mov    %eax,-0x10(%ebp)
    7d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    7d8f:	ff d0                	call   *%eax
    7d91:	c9                   	leave  
    7d92:	c3                   	ret    

00007d93 <waitdisk>:
    7d93:	55                   	push   %ebp
    7d94:	89 e5                	mov    %esp,%ebp
    7d96:	81 ec 00 00 00 00    	sub    $0x0,%esp
    7d9c:	b8 f7 01 00 00       	mov    $0x1f7,%eax
    7da1:	50                   	push   %eax
    7da2:	e8 3c 01 00 00       	call   7ee3 <inb>
    7da7:	83 c4 04             	add    $0x4,%esp
    7daa:	0f b6 c0             	movzbl %al,%eax
    7dad:	81 e0 c0 00 00 00    	and    $0xc0,%eax
    7db3:	83 f8 40             	cmp    $0x40,%eax
    7db6:	0f 84 02 00 00 00    	je     7dbe <waitdisk+0x2b>
    7dbc:	eb de                	jmp    7d9c <waitdisk+0x9>
    7dbe:	c9                   	leave  
    7dbf:	c3                   	ret    

00007dc0 <readsect>:
    7dc0:	55                   	push   %ebp
    7dc1:	89 e5                	mov    %esp,%ebp
    7dc3:	81 ec 00 00 00 00    	sub    $0x0,%esp
    7dc9:	e8 c5 ff ff ff       	call   7d93 <waitdisk>
    7dce:	b8 01 00 00 00       	mov    $0x1,%eax
    7dd3:	50                   	push   %eax
    7dd4:	b8 f2 01 00 00       	mov    $0x1f2,%eax
    7dd9:	50                   	push   %eax
    7dda:	e8 3a 01 00 00       	call   7f19 <outb>
    7ddf:	83 c4 08             	add    $0x8,%esp
    7de2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    7de6:	50                   	push   %eax
    7de7:	b8 f3 01 00 00       	mov    $0x1f3,%eax
    7dec:	50                   	push   %eax
    7ded:	e8 27 01 00 00       	call   7f19 <outb>
    7df2:	83 c4 08             	add    $0x8,%esp
    7df5:	8b 45 0c             	mov    0xc(%ebp),%eax
    7df8:	c1 e8 08             	shr    $0x8,%eax
    7dfb:	0f b6 c0             	movzbl %al,%eax
    7dfe:	50                   	push   %eax
    7dff:	b8 f4 01 00 00       	mov    $0x1f4,%eax
    7e04:	50                   	push   %eax
    7e05:	e8 0f 01 00 00       	call   7f19 <outb>
    7e0a:	83 c4 08             	add    $0x8,%esp
    7e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
    7e10:	c1 e8 10             	shr    $0x10,%eax
    7e13:	0f b6 c0             	movzbl %al,%eax
    7e16:	50                   	push   %eax
    7e17:	b8 f5 01 00 00       	mov    $0x1f5,%eax
    7e1c:	50                   	push   %eax
    7e1d:	e8 f7 00 00 00       	call   7f19 <outb>
    7e22:	83 c4 08             	add    $0x8,%esp
    7e25:	8b 45 0c             	mov    0xc(%ebp),%eax
    7e28:	c1 e8 18             	shr    $0x18,%eax
    7e2b:	81 c8 e0 00 00 00    	or     $0xe0,%eax
    7e31:	0f b6 c0             	movzbl %al,%eax
    7e34:	50                   	push   %eax
    7e35:	b8 f6 01 00 00       	mov    $0x1f6,%eax
    7e3a:	50                   	push   %eax
    7e3b:	e8 d9 00 00 00       	call   7f19 <outb>
    7e40:	83 c4 08             	add    $0x8,%esp
    7e43:	b8 20 00 00 00       	mov    $0x20,%eax
    7e48:	50                   	push   %eax
    7e49:	b8 f7 01 00 00       	mov    $0x1f7,%eax
    7e4e:	50                   	push   %eax
    7e4f:	e8 c5 00 00 00       	call   7f19 <outb>
    7e54:	83 c4 08             	add    $0x8,%esp
    7e57:	e8 37 ff ff ff       	call   7d93 <waitdisk>
    7e5c:	b8 80 00 00 00       	mov    $0x80,%eax
    7e61:	50                   	push   %eax
    7e62:	8b 45 08             	mov    0x8(%ebp),%eax
    7e65:	50                   	push   %eax
    7e66:	b8 f0 01 00 00       	mov    $0x1f0,%eax
    7e6b:	50                   	push   %eax
    7e6c:	e8 89 00 00 00       	call   7efa <insl>
    7e71:	83 c4 0c             	add    $0xc,%esp
    7e74:	c9                   	leave  
    7e75:	c3                   	ret    

00007e76 <readseg>:
    7e76:	55                   	push   %ebp
    7e77:	89 e5                	mov    %esp,%ebp
    7e79:	81 ec 04 00 00 00    	sub    $0x4,%esp
    7e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
    7e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
    7e85:	01 c1                	add    %eax,%ecx
    7e87:	89 4d fc             	mov    %ecx,-0x4(%ebp)
    7e8a:	8b 45 10             	mov    0x10(%ebp),%eax
    7e8d:	81 e0 ff 01 00 00    	and    $0x1ff,%eax
    7e93:	8b 4d 08             	mov    0x8(%ebp),%ecx
    7e96:	29 c1                	sub    %eax,%ecx
    7e98:	89 4d 08             	mov    %ecx,0x8(%ebp)
    7e9b:	8b 45 10             	mov    0x10(%ebp),%eax
    7e9e:	c1 e8 09             	shr    $0x9,%eax
    7ea1:	40                   	inc    %eax
    7ea2:	89 45 10             	mov    %eax,0x10(%ebp)
    7ea5:	8b 45 08             	mov    0x8(%ebp),%eax
    7ea8:	8b 4d fc             	mov    -0x4(%ebp),%ecx
    7eab:	39 c8                	cmp    %ecx,%eax
    7ead:	0f 83 2e 00 00 00    	jae    7ee1 <readseg+0x6b>
    7eb3:	e9 17 00 00 00       	jmp    7ecf <readseg+0x59>
    7eb8:	8b 45 08             	mov    0x8(%ebp),%eax
    7ebb:	81 c0 00 02 00 00    	add    $0x200,%eax
    7ec1:	89 45 08             	mov    %eax,0x8(%ebp)
    7ec4:	8b 45 10             	mov    0x10(%ebp),%eax
    7ec7:	89 c1                	mov    %eax,%ecx
    7ec9:	40                   	inc    %eax
    7eca:	89 45 10             	mov    %eax,0x10(%ebp)
    7ecd:	eb d6                	jmp    7ea5 <readseg+0x2f>
    7ecf:	8b 45 10             	mov    0x10(%ebp),%eax
    7ed2:	50                   	push   %eax
    7ed3:	8b 45 08             	mov    0x8(%ebp),%eax
    7ed6:	50                   	push   %eax
    7ed7:	e8 e4 fe ff ff       	call   7dc0 <readsect>
    7edc:	83 c4 08             	add    $0x8,%esp
    7edf:	eb d7                	jmp    7eb8 <readseg+0x42>
    7ee1:	c9                   	leave  
    7ee2:	c3                   	ret    

00007ee3 <inb>:
    7ee3:	55                   	push   %ebp
    7ee4:	89 e5                	mov    %esp,%ebp
    7ee6:	81 ec 04 00 00 00    	sub    $0x4,%esp
    7eec:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
    7ef0:	ec                   	in     (%dx),%al
    7ef1:	88 45 ff             	mov    %al,-0x1(%ebp)
    7ef4:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
    7ef8:	c9                   	leave  
    7ef9:	c3                   	ret    

00007efa <insl>:
    7efa:	55                   	push   %ebp
    7efb:	89 e5                	mov    %esp,%ebp
    7efd:	81 ec 00 00 00 00    	sub    $0x0,%esp
    7f03:	57                   	push   %edi
    7f04:	8b 55 08             	mov    0x8(%ebp),%edx
    7f07:	8b 7d 0c             	mov    0xc(%ebp),%edi
    7f0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7f0d:	fc                   	cld    
    7f0e:	f3 6d                	rep insl (%dx),%es:(%edi)
    7f10:	89 7d 0c             	mov    %edi,0xc(%ebp)
    7f13:	89 4d 10             	mov    %ecx,0x10(%ebp)
    7f16:	5f                   	pop    %edi
    7f17:	c9                   	leave  
    7f18:	c3                   	ret    

00007f19 <outb>:
    7f19:	55                   	push   %ebp
    7f1a:	89 e5                	mov    %esp,%ebp
    7f1c:	81 ec 00 00 00 00    	sub    $0x0,%esp
    7f22:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    7f26:	0f b7 55 08          	movzwl 0x8(%ebp),%edx
    7f2a:	ee                   	out    %al,(%dx)
    7f2b:	c9                   	leave  
    7f2c:	c3                   	ret    

00007f2d <stosb>:
    7f2d:	55                   	push   %ebp
    7f2e:	89 e5                	mov    %esp,%ebp
    7f30:	81 ec 00 00 00 00    	sub    $0x0,%esp
    7f36:	57                   	push   %edi
    7f37:	8b 7d 08             	mov    0x8(%ebp),%edi
    7f3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
    7f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
    7f40:	fc                   	cld    
    7f41:	f3 aa                	rep stos %al,%es:(%edi)
    7f43:	89 7d 08             	mov    %edi,0x8(%ebp)
    7f46:	89 4d 10             	mov    %ecx,0x10(%ebp)
    7f49:	5f                   	pop    %edi
    7f4a:	c9                   	leave  
    7f4b:	c3                   	ret    
