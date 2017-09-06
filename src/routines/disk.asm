; load DH sectors to ES:BX from drive DL

disk_load:
	pusha
	mov si, 0x02
.read_cyc:
	mov dl, [BOOT_DRIVE]
	mov ah, 0x02
	int 0x13
	jnc .end			; No read errors then we're fine
	dec si				; Otherwise decrement the number of tries left
	jc  .end			; No more tries then give up and let the bootloader handle it
	xor ah, ah		; Prepare for int 0x13 ah 0x02, drive reset
	int 0x13			; Reset drive
	jnc .read_cyc	; Try and read again if there were no problems
.end:
	popa
	ret

get_drive_param:
	pusha
	mov ah, 0x08
	mov dl, 0x00
	xor di, di
	mov es, di
	int 0x13
	mov ax, cx
	or al, 0b00111111
	mov [SECTS_PER_TRACK], al
	mov [NUMBER_OF_CYLS], ah
	popa
	ret

conv_lba:
	xor dx, dx	; Get dx out of the way we don't need it
	mov bx, [SECTS_PER_TRACK]	; Also I hate MiB but eh what can I do about it
	div bx
	; inc dx		; Don't know why that's there so good bye, but I'm too scared to delete it incase it will fix something later
	mov cl, dl	; Store it in the right place for an int 0x13

	xor dx, dx	; Ugh dx again!!!! why does div even use it???!!!!
	mov bx, [NUMBER_OF_CYLS]
	div bx
	mov ch, al	; Stick more stuff in the
	xchg dl, dh	; right place for int 0x13

	ret

get_root_size:
	mov ax, 32		; Bytes per FAT entery
	xor dx, dx
	mov bx, [0x7c00+17]
	mul bx
	mov bx, [0x7c00+11]
	div bx
	mov [ROOT_SECTS], ax
	ret

get_root_start:
	xor ax, ax
	mov al, [0x7c00+16]
	mov bx, [0x7c00+09]
	mul bx
	add ax, [0x7c00+28]
	adc ax, [0x7c00+30]
	add ax, [0x7c00+14]
	mov [ROOT_START], ax
	ret

read_next_sector:
	push cx
	push ax
	xor bx, bx
	call conv_lba
	call disk_load

check_entry:
	mov cx, 11
	mov di, bx
	lea si, [KERNEL_NAME]
	repz cmpsb
	je found_file
 	add bx, 32
 	cmp bx, [0x7c00 + 11]
	jne check_entry

	pop ax
	inc ax
	pop cx
	loopnz read_next_sector
	jmp BOOT_FAIL

found_file:
	mov ax, [es:bx+0x1a]
	mov [FILE_START], ax
