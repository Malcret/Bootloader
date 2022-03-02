[bits 16]

print_string:
    pusha

	mov ah, 0x0e ; write character mode

	.loop:
		cmp [bx], byte 0 ; check string end
		je .exit ; if end, jump to exit
		mov al, [bx] ; set character to print
		int 0x10 ; BIOS interrupt for video services
		inc bx
		jmp .loop

	.exit:
        popa
		ret

clear_screen:
	pusha

	mov ah, 0x07 ; scroll down screen
	mov al, 0x00 ; scroll whole screen
	mov bh, 0x0f ; set color to white on black
	mov ch, 0x00 ; upper row
	mov cl, 0x00 ; left column
	mov dh, 0x18 ; lower row
	mov dl, 0x4f ; right column
	int 0x10 ; BIOS interrupt for video services

	popa
	ret
