; BOOTLOADER

[bits 16]
[org 0x7c00]

; jmp bootloader
; OEM_NAME  db 'L-DOS   '
; BYTES_PER_SECT  dw 512
; SECTS_PER_CLUST db 1
; RESEVED_SECTS   dw 1
; NUMBER_OF_FATS  db 2
; ROOT_ENTERIES   dw 224
; NUMBER_OF_SECTS dw 2880
; MEDIA_DESCRIPT  db 0xf0
; SECTS_PER_FAT   dw 9
; SECTS_PER_TRACK dw 18
; NUMBER_OF_HEADS dw 2
; HIDDEN_SECTS    dd 0
; SECTS_PER_FS    dd 0
; DRIVE_NUMBER    db 0
; db 0
; EXTENED_SIGNATURE db 0x29
; SERIAL_NUM      dd 0
; VOLUME_LABEL    db 'L-DOS      '
; FS_TYPE         db 'FAT12   '

bootloader:
; CLEAR SCREEN
call CLEAR_SCREEN

; MOVE CURSOR TO 0,0
mov ah, 0x02
mov bh, 0x00
xor dx, dx
int 0x10

; PRINT MESSAGE TO SHOW BOOTLOADER IS RUNNING
mov bx, MSG_BOOTSTRAP
call PRINT_STRING



; Load kernel
mov ax, 2       ; I wanna read the second sector, this uses conv_lba
call conv_lba   ; Prepare the geometry stuff for int 0x13
mov al, 1       ; Read 1 sector 'cause I ain't greedy
mov bx, 0x2000  ; Set segement starter
mov es, bx		  ; "					         "
xor bx, bx    	; "					         "
call disk_load

Check for read errors
jnc no_err
mov bx, MSG_READ_ERR
call PRINT_STRING
jmp $

no_err:
mov bx, MSG_LOADED
call PRINT

mov bx, MSG_START
call PRINT_STRING

jmp 0x2000:0x0000

BOOT_FAIL:
  jmp $

%include 'screen.asm'
%include 'disk.asm'
%include 'strings.asm'

MSG_BOOTSTRAP db 'LOADING KERNEL... ', 0
MSG_READ_ERR db 'READ ERROR - CANNOT BOOT', 0
MSG_LOADED db 'LOADING', 0
MSG_START db 'STARTING KERNEL... ', 0
MSG_JUMPING db 'JUMPING...', 0
MSG_KERNEL_NOT_FOUND db 'KERNEL NOT FOUND - CANNOT BOOT', 0
BOOT_DRIVE db 0
KERNEL_NAME db 'MCP     COM', 0   ; Kernel file name, END OF LINE

SECTS_PER_TRACK db 0
NUMBER_OF_CYLS  db 0

times 510-($-$$) db 0
dw 0xaa55
times 512 * 2879 db 0
