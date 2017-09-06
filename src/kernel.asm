; L-DOS

[bits 16]

KERNEL_START:
  mov bx, MSG_KERNEL_START
  call PRINT
  call PRINT_NL

  

  ; Whole OS sists in one segment
  mov ax, 2000h
  mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

MAIN:


  jmp $

%include 'screen.asm'

MSG_KERNEL_START db 'STARTED', 0
