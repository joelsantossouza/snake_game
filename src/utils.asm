global	memmove


memmove:
	mov	rcx, rdx
	cmp	rdi, rsi
	jbe	.copy_forward

	lea	rdi, [rdi + rcx - 1]
	lea	rsi, [rsi + rcx - 1]
	
	std
	rep	movsb
	cld
	ret

.copy_forward:
	cld
	rep	movsb
	ret
