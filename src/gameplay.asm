%include "snake.inc"

extern	map.data
extern	map.fn_set
extern	map.fn_respawn_food

extern	player.positions
extern	player.length
extern	player.next_move
extern	player.fn_grow
extern	player.fn_set_next_move_up
extern	player.fn_set_next_move_down
extern	player.fn_set_next_move_right
extern	player.fn_set_next_move_left
extern	player.fn_set_head_on_map
extern	player.fn_clear_tail_on_map

global	gameplay.is_running
global	gameplay.is_won
global	gameplay.fn_handle_collisions
global	gameplay.fn_handle_key_event
global	gameplay.fn_commit_changes
global	gameplay.fn_update
global	gameplay.fn_delay

gameplay:

section	.data
.is_running:	db TRUE

.is_won:		db FALSE

.delay_timespec:
	dq	0
	dq	GAMEPLAY_DELAY_MAX_NS

section	.text
.fn_start:
	mov	byte [gameplay.is_running], TRUE
	ret

.fn_stop:
	mov	byte [gameplay.is_running], FALSE
	ret

.fn_win:
	mov	byte [gameplay.is_won], TRUE
	call	gameplay.fn_stop
	ret

.fn_lose:
	mov	byte [gameplay.is_won], FALSE
	call	gameplay.fn_stop
	ret

.fn_increase_speed:
	sub	qword [gameplay.delay_timespec + 8], GAMEPLAY_DELAY_STEP_NS
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
	jz	gameplay.fn_handle_food_eaten
	cmp	byte [rax], SYMBOL_EMPTY
	jnz	gameplay.fn_lose
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

.fn_handle_food_eaten:
	call	player.fn_grow
	cmp		qword [player.length], PLAYER_MAX_LENGTH
	jae		gameplay.fn_win
	call	map.fn_respawn_food
	call	gameplay.fn_increase_speed
	ret

.fn_update:
	call	player.fn_clear_tail_on_map
	call	qword [player.next_move]
	ret

.fn_commit_changes:
	call	player.fn_set_head_on_map
	ret
