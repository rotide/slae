global _start

section .text

_start:
	mov eax, 0x66778899
	mov ebx, 0x0
	mov ecx, 0x0
	mov edx, 0x0

	push ax		; should push 3344 onto ESP
	pop bx		; should pop ESP data (3344) into BX

	push eax	; should push 11223344 onto ESP
	pop ecx		; should pop ESP data (11223344) into ECX

	push word [sample]	; should push "3121" onto ESP
	pop ecx			; should pop "3121" into ECX

	push dword [sample]	; should push "3121ffee" onto ESP
	pop edx			; should pop 3121ffee into EDX

	; exit
	mov eax, 1
	mov ebx, 0
	int 0x80

section .data
	sample: db 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff, 0x11, 0x22
