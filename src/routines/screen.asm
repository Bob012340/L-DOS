; PRINT TO SCREEN FUNCTIONS

; Print a string of text
PRINT_STRING:
	pusha
	mov ah, 0x0e

.loop:
	cmp byte [bx], 0
	je .end
	mov al, [bx]
	int 0x10
	add bx, 1
	jmp .loop

.end:
	popa
	ret


; Print new line character
PRINT_NL:
	pusha
	mov ah, 0x0e
	mov al, 0x0d
	int 0x10
	mov al, 0x0a
	int 0x10
	popa
	ret


; Print function that includes return
PRINT:
	call PRINT_STRING
	call PRINT_NL
	mov bx, 0x00000000
	ret


CLEAR_SCREEN:
	mov ah, 0x00
	mov al, 0x03
	int 0x10
	ret
