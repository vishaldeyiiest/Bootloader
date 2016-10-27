;load dh sectors to es:bx from drive dl
disk_read:
	push dx		;store dx on stack so later we can recall how many sectors were requested to be read
	mov ah, 02h	;read sector function
	mov al, dh	;read dh sectors
	mov ch, 0h	;select cylinder 0
	mov dh, 0h	;select head 0
	mov cl, 02h	;start reading from second sector
	
	int 13h		;disk I/0
	jc disk_error1	
	pop dx		;restore dx from the stack
	cmp dh, al	;check if sectors read(al) != sectors expected(dh)
	jne disk_error2
	ret

disk_error1:
	mov bx, DISK_ERROR_MSG1
	call print_string
	jmp wait_on_input
disk_error2:
	mov bx, DISK_ERROR_MSG2
	call print_string
	jmp wait_on_input

DISK_ERROR_MSG1 db 'Disk read error!.', 0
DISK_ERROR_MSG2 db 'sectors read not equal to expected.!', 0
