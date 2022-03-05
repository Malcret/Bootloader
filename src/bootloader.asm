[bits 16]
[org 0x7c00]

KERNEL_SEGMENT equ 0x0000
KERNEL_OFFSET equ 0x7e00

boot:
	mov [BOOT_DRIVE], dl

	; setup segments
    xor ax, ax
    mov ds, ax
	mov es, ax
    mov ss, ax
    mov sp, 0x7c00 ; stack at 0x0000:0x7c00

	call clear_screen

	mov si, msg_load_kernel
	call print_string

	mov al, 0x01 ; number of sectors to read
	mov bx, KERNEL_OFFSET
	mov ch, 0x00 ; cylinder
	mov cl, 0x02 ; sector
	mov dl, [BOOT_DRIVE]
	call disk_load

	call KERNEL_SEGMENT:KERNEL_OFFSET

	jmp halt ; stop cpu

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

print_string:
	lodsb ; load msg first byte from SI

	or al, al
	jz .exit ; if 0 exit

	mov ah, 0x0e ; write character mode
	int 0x10 ; print character

	jmp print_string

	.exit:
		ret

disk_load:
    mov ah, 0x02 ; read mode
    mov dh, 0x00 ; head 0
    
    int 0x13 ; load disk sectors
    jc .failed ; check for errors

    ret

    .failed:
        mov si, .msg_failed ; set msg to print
        call print_string
        jmp halt ; stop

    .msg_failed: db 'Failed to load disk', 0

halt:
	cli
	hlt
	jmp halt

msg_load_kernel: db 'Load kernel...', 0
BOOT_DRIVE: db 0

; set the first sector as a bootloader
times 510 - ($-$$) db 0 ; fill remaining space with 0
dw 0xaa55 ; set bootloader magic number
