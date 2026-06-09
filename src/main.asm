%include "snake.inc"

extern	map.fn_render

extern	gameplay.is_running
extern	gameplay.fn_handle_collisions
extern	gameplay.fn_handle_key_event
extern	gameplay.fn_commit_changes
extern	gameplay.fn_update
extern	gameplay.fn_delay

extern	terminal.fn_get_key_pressed
extern	terminal.fn_clear
extern	terminal.fn_init

global	_start

section	.text
_start:
	call	terminal.fn_init
	call	game_loop
	
	mov		rax, SYSCALL_EXIT
	mov		rdi, 0
	syscall

game_loop:
	call	terminal.fn_clear
	call	terminal.fn_get_key_pressed
	mov		dil, al
	call	gameplay.fn_handle_key_event
	call	gameplay.fn_update
	call	gameplay.fn_handle_collisions

	cmp		byte [gameplay.is_running], FALSE
	jz		.return

	call	gameplay.fn_commit_changes
	call	map.fn_render
	call	gameplay.fn_delay
	jmp		game_loop

.return:
	ret
