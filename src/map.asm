%include "snake.inc"

global	map.data
global	map.size
global	map.row_size
global	map.fn_render
global	map.fn_set

map:

section	.data
.data:
	db	"####################", 0xa
.2nd_row:
	db	"#                  #", 0xa
	db	"#                  #", 0xa
	db	"#                  #", 0xa
	db	"#                  #", 0xa
	db	"#                  #", 0xa
	db	"#                  #", 0xa
	db	"#                  #", 0xa
	db	"#                  #", 0xa
	db	"####################", 0xa
.data_end:

.size:		dq map.data_end - map.data
.row_size:	dq map.2nd_row - map.data

section	.text
.fn_render:
	mov	rax, SYSCALL_WRITE
	mov	rdi, STDOUT_FILENO
	mov	rsi, map.data
	mov	rdx, qword [map.size]
	syscall
	ret

.fn_set:
	mov	byte [map.data + rdi], sil
	ret
