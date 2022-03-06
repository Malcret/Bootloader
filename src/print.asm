[bits 16]

clear_screen:
	mov ah, 0x07 ; scroll down screen
	mov al, 0x00 ; scroll whole screen
	mov bh, 0x0f ; set color to white on black
	mov ch, 0x00 ; upper row
	mov cl, 0x00 ; left column
	mov dh, 0x18 ; lower row
	mov dl, 0x4f ; right column
	int 0x10 ; clear screen

	ret

print_string:
	lodsb ; load msg first byte from SI

	or al, al ; check if not 0
	jz .exit ; if 0 exit

	mov ah, 0x0e ; write character mode
	int 0x10 ; print character

	jmp print_string

	.exit:
		ret
