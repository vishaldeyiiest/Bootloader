print_string:
	mov ah, 0x0e
	.repeat:
        	lodsb                   ;LOAD STRINGBYTES AND STORES IT INTO al
        	cmp al, 0		;IF THERE IS NO BYTES TO READ
        	je .done                ;EXIT FROM THE LOOP AND RETURN
        	int 10h                 ;ELSE PRINT NEXT CHARECTER
        	jmp .repeat

	.done:
       		ret		
