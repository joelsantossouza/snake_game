%include "snake.inc"

global	memmove
global	randrange


section	.text
memmove:
	mov	rcx, rdx
	cmp	rdi, rsi
	jbe	.copy_forward

	lea	rdi, [rdi + rcx - 1]
	lea	rsi, [rsi + rcx - 1]
	
	std
	rep	movsb
	cld
	ret

.copy_forward:
	cld
	rep	movsb
	ret

randrange:
	push	rbp
	mov		rbp, rsp
	sub		rsp, 16

	mov		qword [rbp - 8], rdi

	mov		rax, SYSCALL_GETRANDOM
	lea		rdi, [rbp - 16]
	mov		rsi, 4
	mov		rdx, 0
	syscall

	mov		eax, dword [rbp - 16]
	mov		ebx, dword [rbp - 8]
	div		ebx

	xor		rax, rax
	mov		eax, edx

	add		rsp, 16
	pop		rbp
	ret
