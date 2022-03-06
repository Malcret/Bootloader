[bits 16]

print_string:
	lodsb ; load to al next msg byte from si

	; check if reach the of end of the msg, if true exit
	or al, al
	jz .exit

	mov ah, 0x0e ; write character mode
	int 0x10 ; print character

	jmp print_string

	.exit:
		ret
