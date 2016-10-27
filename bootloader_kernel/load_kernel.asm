[bits 16]
load_kernel:
	mov si, MSG_LOAD_KERNEL    	
	call  print_string	
	mov bx, KERNEL_OFFSET      
	mov dh, 1               ; read 1 sector from 2nd sector vary according to kernel image
	mov dl, [BOOT_DRIVE]    
	call disk_read		; READ THE 2 SECTORS FROM BOOT-DRIVE AND LOAD THEM TO ES:BX REGISTER
	ret
;-----------------------------------------------------------------------------------------------------------------------
[bits  32]
start_pm:
	mov eax, 0x1000  	
	mov ebx, KERNEL_OFFSET 
	cmp ebx, eax	 	
	jne error3		
	call KERNEL_OFFSET      ; load the c program at kernel_pos=0x1000
	jmp $                   
;---------------------------------------------------------------------------------------------------------------------------
	error3:
                jmp start_pm


