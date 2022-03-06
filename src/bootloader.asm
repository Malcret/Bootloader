[bits 16]
[org 0x7c00]

KERNEL_SEGMENT equ 0x0000
KERNEL_OFFSET equ 0x7e00

boot:
	; setup segments
    xor ax, ax
    mov ds, ax
    mov ss, ax
	mov es, ax

	; setup stack
	mov bp, 0x7c00
    mov sp, bp

	mov si, msg_load_kernel ; set msg to print
	call print_string

	call disk_load

	jmp KERNEL_SEGMENT:KERNEL_OFFSET ; far jump to the kernel

halt:
	cli ; disable BIOS interrupt
	hlt ; stop cpu
	jmp halt

msg_load_kernel: db 'Load kernel...', 0

%include "src/print.asm"
%include "src/disk.asm"

; set the first sector as a bootloader
times 510 - ($-$$) db 0 ; fill remaining space with 0
dw 0xaa55 ; set bootloader magic number
