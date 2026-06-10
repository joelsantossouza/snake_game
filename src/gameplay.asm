%include "snake.inc"

extern	map.data
extern	map.fn_set
extern	map.fn_respawn_food

extern	player.positions
extern	player.length
extern	player.next_move
extern	player.fn_set_next_move_up
extern	player.fn_set_next_move_down
extern	player.fn_set_next_move_right
extern	player.fn_set_next_move_left
extern	player.fn_set_on_map
extern	player.fn_clear_on_map

global	gameplay.is_running
global	gameplay.fn_handle_collisions
global	gameplay.fn_handle_key_event
global	gameplay.fn_commit_changes
global	gameplay.fn_update
global	gameplay.fn_delay

gameplay:

section	.rodata
.delay_timespec:
	dq	0
	dq	GAMEPLAY_DELAY_NS

section	.data
.is_running:	db TRUE

section	.text
.fn_start:
	mov	byte [gameplay.is_running], TRUE
	ret

.fn_stop:
	mov	byte [gameplay.is_running], FALSE
	ret

.fn_delay:
	mov	rax, SYSCALL_NANOSLEEP
	mov	rdi, gameplay.delay_timespec
	mov	rsi, 0
	syscall
	ret

.fn_handle_collisions:
	mov	rax, map.data
	add	rax, qword [player.positions]
	cmp	byte [rax], SYMBOL_FOOD
	jz	map.fn_respawn_food
	cmp	byte [rax], SYMBOL_EMPTY
	jnz	gameplay.fn_stop
	ret

.fn_handle_key_event:
	cmp	dil, KEY_MOVE_UP
	jz	player.fn_set_next_move_up
	cmp	dil, KEY_MOVE_DOWN
	jz	player.fn_set_next_move_down
	cmp	dil, KEY_MOVE_RIGHT
	jz	player.fn_set_next_move_right
	cmp	dil, KEY_MOVE_LEFT
	jz	player.fn_set_next_move_left
	ret

.fn_update:
	call	player.fn_clear_on_map
	call	qword [player.next_move]
	ret

.fn_commit_changes:
	call	player.fn_set_on_map
	ret
