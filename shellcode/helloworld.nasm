; helloworld.nasm
; Author: Timo Humphrey

global _start

section .text
_start:
	jmp call_shellcode

shellcode:
	xor eax, eax
	mov al, 0x4
	xor ebx, ebx
	mov bl, 0x1
	;mov ecx, message
	pop ecx			; ESP equals mem addr of message!  Pop that into ecx!
	xor edx, edx
	mov dl, 13
	int 0x80

	mov al, 0x1
	int 0x80

call_shellcode:
	call shellcode				; CALL puts the next line on the stack (addr of message)
	message: db "Hello World!", 0x0a	; ESP now equals the mem addr of this line of code!
