[bits 16]

disk_load:
    pusha

    mov ah, 0x02 ; read mode
    mov dh, 0x00 ; head 0
    
    int 0x13 ; BIOS interrupt low level disk services
    jc .failed ; check for errors

    popa
    ret

    .failed:
        mov bx, .msg_failed ; set msg to print
        call print_string ; print msg
        jmp halt ; stop

    .msg_failed: db 'Failed to load disk', 0
