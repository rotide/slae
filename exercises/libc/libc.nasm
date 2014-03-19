extern printf
extern exit

global main

section .text
main:
	mov [tmp], esp	; preserve ESP
	push message	; push message onto the stack
	call printf	; call libc function "printf"
	mov esp, [tmp]	; reset ESP
	call exit	; exit

section .data
	message: db "Hello World!", 0xA
	message_len equ $-message

section .bss
	tmp: resb 1
