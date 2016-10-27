[org 0x7c00]
KERNEL_OFFSET equ 0x1000	; This is the memory offset to which we will load our kernel
start:
	mov [BOOT_DRIVE], dl	; BIOS stores our boot drive in DL
	
	mov si, MSG_REAL_MODE
	call print_string	; print in real mode
	call wait_on_input
	call load_kernel	; load kernel
	call wait_on_input
	
	call clear_screen
	call switch_to_pm	; making switch to 32-bit
	jmp $

wait_on_input:
	mov ah, 0
	int 16h
	ret

clear_screen:
	mov ax, 0x02
	int 10h
	ret

	%include "print_string.asm"
	%include "disk_read.asm"
	%include "gdt.asm"		
	%include "switch.asm"
	%include "load_kernel.asm"

BOOT_DRIVE db 0
MSG_REAL_MODE:
	dw 0x0d0a
	db "STARTED IN 16-bit REAL MODE...PRESS ANY KEY TO LOAD THE KERNEL..!", 0
	dw 0x0d0a
MSG_PROT_MODE:
	db " Successfully landed in 32-bit Protected Mode ", 0
MSG_LOAD_KERNEL:
	dw 0x0d0a
	dw 0x0d0a
	db "LOADING KERNEL TO MEMEORY....!" , 0

times 510 - ($-$$) db 0
dw 0xaa55
