org 0x7C00
bits  16
mov [bootdrv],dl
start:	
	;mov ax, 07C00h
	;mov ax, 288
	;mov ss, ax
	;mov sp, 4096
	;mov ax, 07C00h		; Set data segment to where we're loaded
	;mov ds, ax
	;cli
	mov si, msg		; move the message to source index
	mov ah, 0Eh		; int 10h 'print char' function	
		
.repeat	lodsb
	cmp al, 0
	je wait_here
	int 10h
	jmp .repeat

wait_here:	
	mov ah, 0		;for waiting function
	int 16h
	mov ah, 0
	int 10h
	mov ah, 0 
	mov al, 13h  	; video mode flag is set to 13h
	int 10h
    
extended_read:
	mov ax, 0x000	; store 0x000 into ax
	mov es, ax       ;move ax to es
	mov bx, 0x1000
	mov ah, 0x2	; read 2nd sector
	mov al,	44	; sectors = ceil(filesize/512)
	mov ch, 0x0	; low 8 bits of the cylinder no
	mov cl, 0x2	; this is the sector no in this case it is 0x2
	mov dh, 0h	;this is the head number this is 0h because I will read from the first byte of the 2nd sector
	mov dl,[bootdrv]	;this the drive from where we will boot the os.
	int 13h		;interrupt 0x13

image: 
	mov ax,0xA000 ; this is the starting address of the video buffer and it is stored into the ax register
	mov es,ax
	mov ax,0x1000
	mov si,ax

	mov dx,20	; top padding
	mov cx,90 	; left padding
	add di,6400
	add di,90	

plot:
	mov al,[si]	;mov the content of address si to al so it will display the image
	inc si	        ;increment si
	stosb           ;stop if there is no string byte to read
	inc cx
	cmp cx,230       
	jne plot
	mov cx,90	; reset the cx for plotting the next row of pixels
	inc dx		
	add di,180	;total 200 padding previous line right 100 padding and next line left 100 padding	
	cmp dx,180
	jne plot

bootdrv db 0
msg:	
	db '....VISHAL DEY...', 0	;null terminated string
	dw 0x0d0a ; to print the messege into the next line
	db "Press any key....!"
	times 510-($-$$) db 0  
	dw 0xaa55	;last two bytes of the MBR is respectively AA and 55; this is called the boot signature
