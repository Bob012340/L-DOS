; ADVANCED POWER MANAGEMENT FUNCTIONS

apm_check:
	mov ah, 0x53
	mov al, 0x00
	xor bx, bx
	int 0x15
	ret

apm_conn_enable:
	mov ah, 0x54
	mov al, 0x01
	xor bx, bx
	int 0x15

	mov ah, 0x54
	mov al, 0x08
	mov bx, 0x0001
	mov	cx, 0x0001
	int 0x15
	ret
