[bits 16]
[org 0x7c00]

KERNEL_OFFSET equ 0x7e00 ; kernel address

start:
	mov [BOOT_DRIVE], dl

	; setup the stack
	mov ax, 0x9000
	mov ss, ax
	mov sp, 4096 ; setup the stack space to 4kiB 
	mov bp, sp ; move the base stack at the bottom of the stack

	call init_segment_registers
	call load_kernel

	jmp halt ; stop cpu

init_segment_registers:
	xor ax, ax
	mov ds, ax
	mov es, ax
	
	ret

load_kernel:
	call clear_screen

	mov bx, msg_load_kernel
	call print_string

	mov al, 0x01 ; number of sectors to read
	mov bx, KERNEL_OFFSET ; buffer address pointer
	mov ch, 0x00 ; cylinder
	mov cl, 0x02 ; sector
	mov dl, [BOOT_DRIVE] ; disk
	call disk_load

	call KERNEL_OFFSET

	ret

halt:
	cli
	hlt
	jmp halt

%include "src/print.asm"
%include "src/disk.asm"

msg_load_kernel: db 'load kernel...', 0
BOOT_DRIVE: db 0

; set the first sector as a bootloader
times 510 - ($-$$) db 0 ; fill remaining space with 0
dw 0xaa55 ; set bootloader magic number
