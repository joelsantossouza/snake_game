%include "snake.inc"

extern	player.length
extern	randrange

global	map.data
global	map.fn_render
global	map.fn_set
global	map.fn_respawn_food

map:

section	.data
.data:
	times MAP_ROW_SIZE - 1 db SYMBOL_WALL
	db NEWLINE, SYMBOL_WALL
	times MAP_ROW_SIZE - 4 db SYMBOL_EMPTY
	db SYMBOL_FOOD, SYMBOL_WALL, NEWLINE
	%rep MAP_COL_SIZE - 3
		db SYMBOL_WALL
		times MAP_ROW_SIZE - 3 db SYMBOL_EMPTY
		db SYMBOL_WALL, NEWLINE
	%endrep
	times MAP_ROW_SIZE - 1 db SYMBOL_WALL

section	.text
.fn_render:
	mov	rax, SYSCALL_WRITE
	mov	rdi, STDOUT_FILENO
	mov	rsi, map.data
	mov	rdx, MAP_SIZE
	syscall
	ret

.fn_set:
	mov	byte [map.data + rdi], sil
	ret

.fn_respawn_food:
	mov		rdi, MAP_WALKABLE_SIZE
	sub		rdi, qword [player.length]
	call	randrange
	mov		rcx, rax
	lea		rax, [map.data + MAP_WALKABLE_FIRST]

.__loop:
	cmp		byte [rax], SYMBOL_EMPTY
	jz		.__verify_index_reached

	cmp		byte [rax], SYMBOL_WALL
	jnz		.__loop_next_cell
	add		rax, 2

.__loop_next_cell:
	add		rax, 1
	jmp		.__loop

.__verify_index_reached:
	cmp		rcx, 0
	jz		.__set_pos
	sub		rcx, 1
	jmp		.__loop_next_cell

.__set_pos:
	mov	byte [rax], SYMBOL_FOOD
	ret
