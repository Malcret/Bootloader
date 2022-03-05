[bits 16]
[org 0x7c00]

KERNEL_SEGMENT equ 0x0000
KERNEL_OFFSET equ 0x7e00

%ifndef DRIVE_SECTOR_NB
	DRIVE_SECTOR_NB equ 1
%endif

boot:
	; setup segments
    xor ax, ax
    mov ds, ax
	mov es, ax
    mov ss, ax
    mov sp, 0x7c00 ; setup stack at 0x0000:0x7c00

	call clear_screen

	mov si, msg_load_kernel ; set msg to print
	call print_string

	call disk_load

	jmp KERNEL_SEGMENT:KERNEL_OFFSET ; far jump to the kernel physical address

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

disk_load:
		mov si, dap_struct ; pointer to the DAP
		mov ah, 0x42 ; extended read sectors mode
		mov dl, 0x80 ; drive index (0x80 = 1st hard disk)
		
		int 0x13 ; read disk sectors
		jc .failed ; if error failed

		ret

    .failed:
        mov si, .msg_load_failed ; set msg to print
        call print_string
        jmp halt

    .msg_load_failed: db 'Failed to load drive', 0

halt:
	cli ; disable BIOS interrupt
	hlt ; stop cpu
	jmp halt

msg_load_kernel: db 'Load kernel...', 0

dap_struct:
	db 0x10 ; size of the DAP
	db 0 ; unused, set to 0
	dw DRIVE_SECTOR_NB ; number of sectors to be read
	dw KERNEL_OFFSET ; offset pointer to the memory buffer to which sectors will be transferred
	dw KERNEL_SEGMENT ; segment pointer to the memory buffer to which sectors will be transferred
	dd 1 ; lower halt of the start of the sectors to be read
	dd 0 ; upper halt of the start of the sectors to be read

; set the first sector as a bootloader
times 510 - ($-$$) db 0 ; fill remaining space with 0
dw 0xaa55 ; set bootloader magic number
