; Executable	: eatclib
; Description	: Invoke puts and printf standard c lib function
;		  from assembly program.
; Build		:
;	nasm -f elf64 -g -F dwarf eatclib.asm
;	gcc -o eatclib eatclib.o

; Initialized data section
SECTION .data
	Message db "Eat at Joe's!",0
	Format db "%s, %d, %d, %d, %d",10,0

; Uninitialized data section
SECTION .bss

; Code
SECTION .text

extern puts, printf		; Include puts and printf function from glibc
global main			; gcc treat main as the entry point

main:
	push rbp		; Backup the caller's frame
	mov rbp, rsp		; Create a new frame
	push rbx		; Backup registers which must be preserved
	push rsi
	push rdi

; Now we can invoke the c function
;	push Message		; Pass argument through stack
	mov rdi, Message	; In 64bit, pass argument through rdi
	call puts		; Call glibc function
	add rsp, 8		; Clean stack by move rsp up 8 bytes

; Invoke printf(Format, Message, 2, 2, 5, 2)
	mov rdi, Format		; printf format string
	mov rsi, Message	; Message
	mov rdx, 2
	mov rcx, 2
	mov r8, 5
	mov r9, 2
	call printf

	pop rdi			; Restore saved registers
	pop rsi
	pop rbx
	mov rsp, rbp		; Destroy stack frame before returning
	pop rbp
	ret			; Return control to Linux
