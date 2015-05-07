; Executable name	: uppercase
; Description		: Convert content to uppercase from lowercase from
;			  stdin and output to stdout.
; Build			:

SECTION	.bss
	BufLen equ 1024		; Buffer length
	Buff: resb BufLen	; Define a buffer

SECTION .data

SECTION .code

global _start			; Entry point

_start:
	nop			; For gdb
Read:
	mov eax, 3		; sys_read syscall
	mov ebx, 0		; read from stdin
	mov ecx, Buff		; Offset of the buffer
	mov edx, BufLen		; Buffer length
	int 80h			; Linux syscall interrupt
	cmp eax, 0		; Check read bytes
	jz Done			; If no data is read(EOF), goto done label

; Prepare base pointer and data length for scan
	mov esi, eax		; data length backup
	mov ecx, eax		; data length to scan
	mov ebx, Buff		; Base pointer
	dec ebx			; Adjust pointer to the last byte

; Scan the buffer and convert a-z to UpperCase
Scan:
	cmp byte [ebx+ecx], 61h	; Test input char against 'a'
	jb Next			; If below 'a' in ASCII, not lowercase
	cmp byte [ebx+ecx], 7Ah	; Test input char against 'z'
	ja Next			; If above 'z' in ASCII, not lowercase
	sub byte [ebx+ecx], 20h	; Substract 20h to convert to uppercase
Next:
	dec ecx			; Descrease counter
	jnz Scan		; If still have chars, scan again

Write:
	mov eax, 4		; sys_write syscall
	mov ebx, 1		; wirite to stdout
	mov ecx, Buff		; Offset of the buffer
	mov edx, esi		; Data length to write
	int 80h			; Make sys_write kernel call
	jmp Read		; Loop back to load another buffer

Done:
	mov eax, 1		; sys_exit syscall
	mov ebx, 0		; return value 0
	int 80h			; Linux syscall interrupt
