NAME		:= snake

SRCS_DIR	:= src
INCS_DIR	:= include

SRCS		:= $(addprefix $(SRCS_DIR)/, \
			   main.asm \
			   player.asm \
			   map.asm \
			   gameplay.asm \
			   terminal.asm \
			   utils.asm \
)
OBJS		:= $(SRCS:.asm=.o)
INCS		:= -I $(INCS_DIR)

LD			:= ld
AS			:= nasm
RM			:= rm

AFLAGS		:= -f elf64 -g
RMFLAGS		:= -f

all: $(NAME)

$(NAME): $(OBJS)
	$(LD) $^ -o $@

%.o: %.asm
	$(AS) $(AFLAGS) $(INCS) $< -o $@

clean:
	$(RM) $(RMFLAGS) $(OBJS)

fclean: clean
	$(RM) $(RMFLAGS) $(NAME)

re: fclean all

.PHONY: all clean fclean re
