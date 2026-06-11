%include "snake.inc"

extern	map.fn_render

extern	gameplay.is_running
extern	gameplay.is_won
extern	gameplay.fn_handle_collisions
extern	gameplay.fn_handle_key_event
extern	gameplay.fn_commit_changes
extern	gameplay.fn_update
extern	gameplay.fn_delay

extern	terminal.fn_get_key_pressed
extern	terminal.fn_clear
extern	terminal.fn_init

global	_start

section	.rodata
win_screen:
	%rep MAP_COL_SIZE / 2
		times MAP_ROW_SIZE - 1 db SYMBOL_BACKGROUND
		db NEWLINE
	%endrep
	times (MAP_ROW_SIZE - GAMEPLAY_WIN_MSG_LEN) / 2 db SYMBOL_BACKGROUND
	db GAMEPLAY_WIN_MSG
	times (MAP_ROW_SIZE - MAP_ROW_SIZE % 2 - GAMEPLAY_WIN_MSG_LEN) / 2 db SYMBOL_BACKGROUND
	db NEWLINE
	%rep MAP_COL_SIZE / 2
		times MAP_ROW_SIZE - 1 db SYMBOL_BACKGROUND
		db NEWLINE
	%endrep

lose_screen:
	%rep MAP_COL_SIZE / 2
		times MAP_ROW_SIZE - 1 db SYMBOL_BACKGROUND
		db NEWLINE
	%endrep
	times (MAP_ROW_SIZE - GAMEPLAY_LOSE_MSG_LEN) / 2 db SYMBOL_BACKGROUND
	db GAMEPLAY_LOSE_MSG
	times (MAP_ROW_SIZE - MAP_ROW_SIZE % 2 - GAMEPLAY_LOSE_MSG_LEN) / 2 db SYMBOL_BACKGROUND
	db NEWLINE
	%rep MAP_COL_SIZE / 2
		times MAP_ROW_SIZE - 1 db SYMBOL_BACKGROUND
		db NEWLINE
	%endrep

section	.text
_start:
	call	terminal.fn_init
	call	game_loop

	cmp		byte [gameplay.is_won], TRUE
	jz		.__win

	mov		rsi, lose_screen
	jmp		.__screen_display

.__win:
	mov		rsi, win_screen

.__screen_display:
	mov		rax, SYSCALL_WRITE
	mov		rdi, STDOUT_FILENO
	mov		rdx, MAP_SIZE
	syscall
	jmp		__exit

game_loop:
	call	terminal.fn_clear
	call	terminal.fn_get_key_pressed
	mov		dil, al
	call	gameplay.fn_handle_key_event
	call	gameplay.fn_update
	call	gameplay.fn_handle_collisions

	cmp		byte [gameplay.is_running], FALSE
	jz		__return

	call	gameplay.fn_commit_changes
	call	map.fn_render
	call	gameplay.fn_delay
	jmp		game_loop

__return:
	ret

__exit:
	mov		rax, SYSCALL_EXIT
	mov		rdi, 0
	syscall
