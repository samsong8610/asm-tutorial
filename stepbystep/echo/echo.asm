; executable name	: echo
; description		: Echo arguments each a line to stdout.
;
; build	:
;	nasm -f elb64 -g -F dwarf echo.asm
;	ld -o echo echo.o

; Initialized data
SECTION .data
	ErrMsg db "Some error occured!", 10	; Error message
	ErrLen equ $-ErrMsg			; Error message length

; Uninitialized data
SECTION .bss
	MaxArgs equ 10				; Maximum # of arguments
	ArgCount resd 1				; The actual # of arguments
	ArgAddrs resq MaxArgs			; The arguments address array
	ArgLens resd MaxArgs			; The arguments length array

; Code section
SECTION .text
	global _start				; Entry point
_start:
	nop					; Make gdb happy

; Scan all the arguments
	pop rcx					; Get the # of the arguments
	cmp rcx, MaxArgs			; Check if passed more than max args
	ja Error				; If above max args, print error message
	mov dword [ArgCount], ecx		; Save argument count
	xor esi, esi				; Clean esi to 0
Scan:
	pop qword [ArgAddrs+esi*8]		; Save 64-bit argument address into ArgAddres array
	inc esi					; Increase scaned argument count
	cmp esi, ecx				; Compare scaned count with total count
	jb Scan					; If below, do scan again

; Determine each arguemnt length
	mov ecx, 0000ffffh			; Max scan 65535 bytes
	xor ebx, ebx				; Use ebx as ArgAddrs array index
	xor eax, eax				; Clear eax to scan string for 0
CalLen:
	mov rdi, [ArgAddrs+ebx*8]		; Put string begin address in edi
	mov rdx, rdi				; Backup edi in edx
	cld					; Scan upword
	repne scasb
	jnz Error				; If not found, print error message
	mov byte [rdi-1], 10			; Replace NULL with EOL
	sub rdi, rdx				; Calculate argument length
	mov dword [ArgLens+ebx*4], edi		; Store argument length into ArgLens array
	inc ebx					; Increase argument count
	cmp ebx, [ArgCount]			; Compare with total argument count
	jb CalLen				; If has more argument, calculate again

; Print argument into stdout
	xor ebx, ebx				; Clear ebx, use as argument count
PrintArg:
	mov rax, 1				; Call sys_write
	mov rdi, 1				; Output into stdout
	mov rsi, [ArgAddrs+ebx*8]		; Set argument begin address
	xor rdx, rdx				; Clear rdx
	mov edx, [ArgLens+ebx*4]		; Set argument length, size dword
	syscall					; Invoke syscall
	inc ebx					; Next argument
	cmp ebx, [ArgCount]			; Has more argument
	jb PrintArg				; Print another argument
	mov ebx, 0				; Process successfully, return 0
	jmp Exit				; Exit 

Error:
	mov eax, 4				; Call sys_write
	mov ebx, 1				; Output into stderr
	mov rcx, ErrMsg				; Set error message address
	mov edx, ErrLen				; Set message length
	int 80h					; Invoke syscall
	mov ebx, 1				; Has error, so return 1

Exit:
	mov eax, 1				; Call sys_exit
	int 80h					; Invoke syscall
