%include "snake.inc"

global	terminal.fn_get_key_pressed
global	terminal.fn_clear
global	terminal.fn_init

terminal:

section	.rodata
.cmd_clear:		db 0q033, "[H", 0q033, "[2J"
.cmd_clear_len:	dq $ - .cmd_clear

section	.text
.fn_init:
	push	rbp
	mov		rbp, rsp
	sub		rsp, 64

	mov		rax, SYSCALL_IOCTL
	mov		rdi, STDIN_FILENO
	mov		rsi, TCGETS
	lea		rdx, [rbp - 64]
	syscall
	cmp		rax, 0
	jl		__error_handler

	lea		rax, [rbp - 64]
	and		dword [rax + 12], ~(ICANON | ECHO)
	mov		word [rax + 22], 0

	mov		rax, SYSCALL_IOCTL
	mov		rdi, STDIN_FILENO
	mov		rsi, TCSETS
	lea		rdx, [rbp - 64]
	syscall
	cmp		rax, 0
	jl		__error_handler

	add		rsp, 64
	pop		rbp
	ret

.fn_get_key_pressed:
	push	rbp
	mov		rbp, rsp
	sub		rsp, 8

	mov	rax, SYSCALL_READ
	mov	rdi, STDIN_FILENO
	lea	rsi, [rbp - 8]
	mov	rdx, 1
	syscall

	mov		al, byte [rbp - 8]

	add		rsp, 8
	pop		rbp
	ret

.fn_clear:
	mov	rax, SYSCALL_WRITE
	mov	rdi, STDOUT_FILENO
	mov	rsi, terminal.cmd_clear
	mov	rdx, qword [terminal.cmd_clear_len]
	syscall
	ret

__error_handler:
	mov	rax, -1
	ret
