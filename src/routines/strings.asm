; Compare two stings
strcmp:
	.loop:
	mov al, [si]   ; grab a byte from SI
	mov bl, [di]   ; grab a byte from DI
	cmp al, 0
	je .done
	cmp al, bl     ; are they equal?
	jne .notequal  ; nope, we're done.

	inc di     ; increment DI
	inc si     ; increment SI
	jmp .loop  ; loop!

	.notequal:
	clc  ; not equal, clear the carry flag
	ret

	.done:
	stc  ; equal, set the carry flag
	ret
