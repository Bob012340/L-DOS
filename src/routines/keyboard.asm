; KEYBOARD FUNCTIONS

; Read input routine
READ_INPUT:
	pusha

	xor cl, cl			; use CX to hold number of characters typed

.loop:
	mov ah, 0x0000
	int 0x16

	cmp al, 0x08
	je .backspace

	cmp al, 0x0D
	je .done

	cmp cl, 0x3F
	je .loop

	mov ah, 0x0E
	int 0x10

	stosb
	inc cl
	jmp .loop

.backspace:
	cmp cl, 0x0000
	je .loop

	dec di
	mov byte [di], 0
	dec cl

	mov ah, 0x0E
	mov al, 0x08
	int 10h

	mov al, ' '
	int 10h

	mov al, 0x08
	int 10h

	jmp .loop

.done:
	mov al, 0
	stosb

	call print_nl

	popa
	ret
