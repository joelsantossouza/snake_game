%include "snake.inc"

extern	map.fn_set
extern	memmove

global	player.next_move
global	player.positions
global	player.length
global	player.fn_grow
global	player.fn_set_next_move_up
global	player.fn_set_next_move_down
global	player.fn_set_next_move_right
global	player.fn_set_next_move_left
global	player.fn_set_on_map
global	player.fn_clear_on_map

player:

section	.data
.positions:	times PLAYER_MAX_LENGTH dq MAP_WALKABLE_FIRST
.length:	dq 1
.next_move:	dq player.fn_move_right

section	.text
.fn_grow:
	mov	rax, qword [player.length]
	cmp	rax, PLAYER_MAX_LENGTH
	jae	__return
	lea	rax, [player.positions + rax * 8]
	mov	rbx, qword [rax - 8]
	mov	qword [rax], rbx
	add	qword [player.length], 1
	ret

.fn_move_up:
	mov		rdi, qword [player.positions]
	sub		rdi, MAP_ROW_SIZE
	call	__push_position
	ret

.fn_move_down:
	mov		rdi, qword [player.positions]
	add		rdi, MAP_ROW_SIZE
	call	__push_position
	ret

.fn_move_right:
	mov		rdi, qword [player.positions]
	add		rdi, 1
	call	__push_position
	ret

.fn_move_left:
	mov		rdi, qword [player.positions]
	sub		rdi, 1
	call	__push_position
	ret

.fn_set_next_move_up:
	mov	qword [player.next_move], player.fn_move_up
	ret

.fn_set_next_move_down:
	mov	qword [player.next_move], player.fn_move_down
	ret

.fn_set_next_move_right:
	mov	qword [player.next_move], player.fn_move_right
	ret

.fn_set_next_move_left:
	mov	qword [player.next_move], player.fn_move_left
	ret

.fn_set_on_map:
	mov		rdi, qword [player.positions]
	mov		sil, SYMBOL_PLAYER
	call	map.fn_set
	ret

.fn_clear_on_map:
	mov		rax, [player.length]
	mov		rdi, qword [player.positions + (rax - 1) * 8]
	mov		sil, SYMBOL_EMPTY
	call	map.fn_set
	ret

__push_position:
	push	rbp
	mov		rbp, rsp
	sub		rsp, 8

	mov		qword [rbp - 8], rdi

	lea		rdi, [player.positions + 8]
	mov		rsi, player.positions
	mov		rdx, qword [player.length]
	lea		rdx, [(rdx - 1) * 8]
	call	memmove

	mov		rax, qword [rbp - 8]
	mov		qword [player.positions], rax

	add		rsp, 8
	pop		rbp
	ret

__return:
	ret
