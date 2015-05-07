; Executal name	: eatsyscall
; Description	: A simple assembly application to demonstrating the use of 
;		  Linux INT 80H syscalls to display a string.
; Build		: nasm -f elf -g -F stabs eatsyscall.asm
;		  ld -o eatsyscall eatsyscall.o

SECTION .data		; Section containing initialized data
EatMsg:	db "Eat at Sam's!",10
EatLen: equ $-EatMsg

SECTION .bss		; Section containing uninitialized data

SECTION .text		; Section containing code

global _start		; Linker needs this to find the entry point!

_start:
	nop		; gdb need this no-op
	mov eax, 4	; Specify sys_write syscall
	mov ebx, 1	; Specify File Descriptor 1: Standard Output
	mov ecx, EatMsg	; Pass offset of the message
	mov edx, EatLen	; Pass the length of the message
	int 80H		; Make syscall to output the text to stdout

	mov eax, 1	; Specify Exit syscall
	mov ebx, 0	; Return a code of zero
	int 80H		; Make syscall to terminate 

