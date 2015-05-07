; Executal name	: eatsyscall64
; Description	: A simple 64-bit assembly application to demonstrating the use 
;		  of Linux syscall to display a string.
; Build		: nasm -f elf64 -g -F stabs eatsyscall64.asm
;		  ld -o eatsyscall64 eatsyscall64.o

SECTION .data		; Section containing initialized data
EatMsg:	db "Eat at Sam's!",10
EatLen: equ $-EatMsg

SECTION .bss		; Section containing uninitialized data

SECTION .text		; Section containing code

global _start		; Linker needs this to find the entry point!

_start:
	nop		; gdb need this no-op
	mov rax, 1	; Specify sys_write syscall
	mov rdi, 1	; Specify File Descriptor 1: Standard Output
	mov rsi, EatMsg	; Pass offset of the message
	mov rdx, EatLen	; Pass the length of the message
	syscall		; Make syscall to output the text to stdout

	mov rax, 60	; Specify Exit syscall, id 60
	mov rdi, 0	; Return a code of zero
	syscall		; Make syscall to terminate 

