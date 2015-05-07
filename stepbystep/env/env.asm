; Executable	:	env
; Description	:	Print all env variables into stdout
; Build		:
; 	nasm -f elf64 -g -F dwarf env.asm
;	ld -o env env.o

; Constants
%define	EOL		0ah
%define SYS_WRITE	1
%define SYS_EXIT	60
%define STDOUT		1

; Initialized data
SECTION .data
	ErrMsg db 'Some error occured!', EOL
	ErrLen equ $-ErrMsg

SECTION .text

global _start

_start:
	nop				; Make gdb happy
	mov rbp, rsp			; Store the current frame
	mov rcx, [rbp]			; Get the argument count
	lea rbx, [rbp+16+rcx*8]		; Ignore arguments
	xor rcx, rcx			; Use rcx as env counter

; Iterate all env strings
.ScanEnv:
	mov rsi, [rbx+rcx*8]		; Get the address of the env
	cmp rsi, 0			; Check if env string is NULL
	je .Exit			; If so, exit

; Calculate the length of the current env
	push rcx			; Backup current env index
	xor rax, rax			; Find 0 of the env string
	mov rdi, rsi			; Store env begin address in rdi
	mov rdx, rsi			; Back begin address in rdx
	mov rcx, 0ffffh			; Max env string length 65535
	repnz scasb			; Find AL(0) in rdi
	jnz .Error			; Not found AL, print error message
	mov byte [rdi-1], EOL		; Replace 0 with EOL
	sub rdi, rdx			; Calculate the length

; Print env string to stdout
	mov rax, SYS_WRITE		; sys_write
	mov rdx, rdi			; Env string in rsi, length in rdx
	mov rdi, STDOUT			; Output to stdout
	syscall				; Invoke syscall
	pop rcx				; Restore the current env index
	inc rcx				; Process next env
	jmp .ScanEnv

.Error:
	mov rax, SYS_WRITE		; sys_write
	mov rdi, STDOUT			; Output to stdout
	mov rsi, ErrMsg			; Error message
	mov rdx, ErrLen			; Error message length
	syscall				; Invoke syscall

.Exit:
	mov rax, SYS_EXIT		; sys_exit 
	mov rbx, 0			; With return code 0
	syscall				; Invoke syscall
