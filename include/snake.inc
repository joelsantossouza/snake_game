%define TRUE				1
%define FALSE				0

%define SYSCALL_WRITE		1
%define SYSCALL_READ		0
%define SYSCALL_IOCTL		16
%define SYSCALL_NANOSLEEP	35
%define SYSCALL_EXIT		60

%define STDOUT_FILENO		1
%define STDIN_FILENO		0

%define TCSETS				0x5402
%define TCGETS				0x5401

%define ICANON				0x02
%define ECHO				0x08

%define	KEY_MOVE_UP			"w"
%define	KEY_MOVE_DOWN		"s"
%define	KEY_MOVE_RIGHT		"d"
%define	KEY_MOVE_LEFT		"a"

%define EMPTY_SYMBOL		" "
%define PLAYER_SYMBOL		"@"
%define PLAYER_MAX_LENGTH	5

%define GAMEPLAY_DELAY_MS	100
%assign GAMEPLAY_DELAY_NS	GAMEPLAY_DELAY_MS * 1000000
