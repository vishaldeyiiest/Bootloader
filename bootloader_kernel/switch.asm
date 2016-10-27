[bits 16]
	; Switch to protected mode
switch_to_pm :
	cli		; We must switch of interrupts until we have
			; set-up the protected mode interrupt vector
			; otherwise interrupts will run riot.
	lgdt [gdt_descriptor]	; load GDT for code and data
	mov eax, cr0		; switch to protected mode
	or eax, 0x1		; set first bit of CRO(control register)
	mov cr0, eax
	jmp CODE_SEG:init_pm	; make a far jump to our 32-bit code
				; causes flushing of cache of pre-fetched instructions
[bits 32]
	; initialise registers and stacks once in PM
init_pm:
	mov ax, DATA_SEG	; oldsegments are discarded
	mov ds, ax		; point all segment registers to data selector in GDT
	mov ss, ax
	mov es, ax	
	mov fs, ax
	mov gs, ax
	mov ebp, 0x90000	; update stack position so that it is at top of free space
	mov esp, ebp
	call start_pm

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
	
