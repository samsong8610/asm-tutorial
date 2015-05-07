	.file	"eatclib.c"
	.section	.rodata
.LC0:
	.string	"%s, %d, %d, %d, %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movabsq	$5341397118566555973, %rax
	movq	%rax, -16(%rbp)
	movl	$1931961711, -8(%rbp)
	movw	$33, -4(%rbp)
	leaq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	puts
	leaq	-16(%rbp), %rax
	movl	$2, %r9d
	movl	$5, %r8d
	movl	$2, %ecx
	movl	$2, %edx
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.9.2 20150212 (Red Hat 4.9.2-6)"
	.section	.note.GNU-stack,"",@progbits
