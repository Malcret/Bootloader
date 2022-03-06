[bits 16]

%ifndef DRIVE_SECTOR_NB
	DRIVE_SECTOR_NB equ 1
%endif

disk_load:
		mov si, dap_struct ; pointer to the DAP
		mov ah, 0x42       ; extended read sectors mode
		mov dl, 0x80       ; drive index (0x80 = 1st hard disk)
		
		int 0x13   ; read disk sectors
		jc .failed ; if error failed

		ret

    .failed:
        mov si, .msg_load_failed ; set msg to print
        call print_string
        jmp halt

    .msg_load_failed: db 'Failed to load drive', 0

dap_struct:
	db 0x10            ; size of the DAP
	db 0               ; unused, set to 0
	dw DRIVE_SECTOR_NB ; number of sectors to be read
	dw KERNEL_OFFSET   ; offset pointer to the memory buffer to which sectors will be transferred
	dw KERNEL_SEGMENT  ; segment pointer to the memory buffer to which sectors will be transferred
	dd 1               ; lower halt of the start of the sectors to be read
	dd 0               ; upper halt of the start of the sectors to be read
