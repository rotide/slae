; helloworld.nasm
; Author: Timo Humphrey

global _start

section .text
_start:
	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, message
	mov edx, message_len
	int 0x80

	mov eax, 0x1
	mov ebx, 0x0
	int 0x80

section .data
	message: db "Hello World!", 0x0a
	message_len: equ $-message
