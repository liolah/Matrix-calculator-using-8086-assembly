	.file	"matrix.c"
	.text
	.section .rdata,"dr"
.LC0:
	.ascii "%d\11\0"
	.text
	.globl	print
	.def	print;	.scl	2;	.type	32;	.endef
	.seh_proc	print
print:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movq	%rcx, 16(%rbp)
	movl	%edx, 24(%rbp)
	movl	%r8d, 32(%rbp)
	movl	$10, %ecx
	call	putchar
	movl	$0, -4(%rbp)
	jmp	.L2
.L5:
	movl	$0, -8(%rbp)
	jmp	.L3
.L4:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	16(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %eax
	movl	%eax, %edx
	leaq	.LC0(%rip), %rax
	movq	%rax, %rcx
	call	printf
	addl	$1, -8(%rbp)
.L3:
	movl	-8(%rbp), %eax
	cmpl	32(%rbp), %eax
	jl	.L4
	movl	$10, %ecx
	call	putchar
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cmpl	24(%rbp), %eax
	jl	.L5
	movl	$10, %ecx
	call	putchar
	nop
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC1:
	.ascii "Invalid matrices dimensions for multiplication!\0"
	.text
	.globl	mul
	.def	mul;	.scl	2;	.type	32;	.endef
	.seh_proc	mul
mul:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movq	%rcx, 16(%rbp)
	movl	%edx, 24(%rbp)
	movl	%r8d, 32(%rbp)
	movq	%r9, 40(%rbp)
	movl	32(%rbp), %eax
	cmpl	48(%rbp), %eax
	jne	.L7
	cmpl	$0, 32(%rbp)
	je	.L7
	cmpl	$0, 24(%rbp)
	je	.L7
	cmpl	$0, 56(%rbp)
	jne	.L8
.L7:
	leaq	.LC1(%rip), %rax
	movq	%rax, %rcx
	call	puts
	jmp	.L6
.L8:
	movl	$0, -4(%rbp)
	jmp	.L10
.L15:
	movl	$0, -8(%rbp)
	jmp	.L11
.L14:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	64(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	$0, (%rdx,%rax,4)
	movl	$0, -12(%rbp)
	jmp	.L12
.L13:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	64(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %r8d
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	16(%rbp), %rax
	addq	%rax, %rdx
	movl	-12(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %ecx
	movl	-12(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	40(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %eax
	imull	%eax, %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	64(%rbp), %rax
	addq	%rax, %rdx
	addl	%r8d, %ecx
	movl	-8(%rbp), %eax
	cltq
	movl	%ecx, (%rdx,%rax,4)
	addl	$1, -12(%rbp)
.L12:
	movl	-12(%rbp), %eax
	cmpl	56(%rbp), %eax
	jl	.L13
	addl	$1, -8(%rbp)
.L11:
	movl	-8(%rbp), %eax
	cmpl	56(%rbp), %eax
	jl	.L14
	addl	$1, -4(%rbp)
.L10:
	movl	-4(%rbp), %eax
	cmpl	24(%rbp), %eax
	jl	.L15
	movl	56(%rbp), %ecx
	movl	24(%rbp), %edx
	movq	64(%rbp), %rax
	movl	%ecx, %r8d
	movq	%rax, %rcx
	call	print
	nop
.L6:
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC2:
	.ascii "Invalid matrices dimensions for addition!\0"
	.text
	.globl	add
	.def	add;	.scl	2;	.type	32;	.endef
	.seh_proc	add
add:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movq	%rcx, 16(%rbp)
	movl	%edx, 24(%rbp)
	movl	%r8d, 32(%rbp)
	movq	%r9, 40(%rbp)
	movl	24(%rbp), %eax
	cmpl	48(%rbp), %eax
	jne	.L17
	movl	32(%rbp), %eax
	cmpl	56(%rbp), %eax
	jne	.L17
	cmpl	$0, 32(%rbp)
	je	.L17
	cmpl	$0, 24(%rbp)
	jne	.L18
.L17:
	leaq	.LC2(%rip), %rax
	movq	%rax, %rcx
	call	puts
	jmp	.L16
.L18:
	movl	$0, -4(%rbp)
	jmp	.L20
.L23:
	movl	$0, -8(%rbp)
	jmp	.L21
.L22:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	16(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %r8d
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	40(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	64(%rbp), %rax
	addq	%rax, %rdx
	addl	%r8d, %ecx
	movl	-8(%rbp), %eax
	cltq
	movl	%ecx, (%rdx,%rax,4)
	addl	$1, -8(%rbp)
.L21:
	movl	-8(%rbp), %eax
	cmpl	32(%rbp), %eax
	jl	.L22
	addl	$1, -4(%rbp)
.L20:
	movl	-4(%rbp), %eax
	cmpl	24(%rbp), %eax
	jl	.L23
	movl	32(%rbp), %ecx
	movl	24(%rbp), %edx
	movq	64(%rbp), %rax
	movl	%ecx, %r8d
	movq	%rax, %rcx
	call	print
	nop
.L16:
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.section .rdata,"dr"
	.align 8
.LC3:
	.ascii "Invalid matrices dimensions for subtraction!\0"
	.text
	.globl	sub
	.def	sub;	.scl	2;	.type	32;	.endef
	.seh_proc	sub
sub:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	movq	%rcx, 16(%rbp)
	movl	%edx, 24(%rbp)
	movl	%r8d, 32(%rbp)
	movq	%r9, 40(%rbp)
	movl	24(%rbp), %eax
	cmpl	48(%rbp), %eax
	jne	.L25
	movl	32(%rbp), %eax
	cmpl	56(%rbp), %eax
	jne	.L25
	cmpl	$0, 32(%rbp)
	je	.L25
	cmpl	$0, 24(%rbp)
	jne	.L26
.L25:
	leaq	.LC3(%rip), %rax
	movq	%rax, %rcx
	call	puts
	jmp	.L24
.L26:
	movl	$0, -4(%rbp)
	jmp	.L28
.L31:
	movl	$0, -8(%rbp)
	jmp	.L29
.L30:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	16(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %ecx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	40(%rbp), %rax
	addq	%rax, %rdx
	movl	-8(%rbp), %eax
	cltq
	movl	(%rdx,%rax,4), %r8d
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	movq	%rax, %rdx
	movq	64(%rbp), %rax
	addq	%rax, %rdx
	subl	%r8d, %ecx
	movl	-8(%rbp), %eax
	cltq
	movl	%ecx, (%rdx,%rax,4)
	addl	$1, -8(%rbp)
.L29:
	movl	-8(%rbp), %eax
	cmpl	32(%rbp), %eax
	jl	.L30
	addl	$1, -4(%rbp)
.L28:
	movl	-4(%rbp), %eax
	cmpl	24(%rbp), %eax
	jl	.L31
	movl	32(%rbp), %ecx
	movl	24(%rbp), %edx
	movq	64(%rbp), %rax
	movl	%ecx, %r8d
	movq	%rax, %rcx
	call	print
	nop
.L24:
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
	.align 8
.LC4:
	.ascii "Enter the dimensions of matrix A:\0"
.LC5:
	.ascii "Number of rows: \11\0"
.LC6:
	.ascii "%d\0"
.LC7:
	.ascii "Number of columns: \11\0"
	.align 8
.LC8:
	.ascii "Enter the values in matrix A in row major order:\0"
	.align 8
.LC9:
	.ascii "Enter the dimensions of matrix B:\0"
	.align 8
.LC10:
	.ascii "Enter the values in matrix B in row major order:\0"
	.align 8
.LC11:
	.ascii "Select the required operation (A ? B) (+ - *):\0"
.LC12:
	.ascii " %c\0"
	.align 8
.LC13:
	.ascii "The result matrix of adding the matrices A and B is:\0"
	.align 8
.LC14:
	.ascii "The result matrix of subtracting the matrices A and B is:\0"
	.align 8
.LC15:
	.ascii "The result matrix of multiplying the matrices A and B is:\0"
.LC16:
	.ascii "Invalid operation!\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	subq	$1320, %rsp
	.seh_stackalloc	1320
	leaq	128(%rsp), %rbp
	.seh_setframe	%rbp, 128
	.seh_endprologue
	call	__main
	leaq	752(%rbp), %rdx
	movl	$0, %eax
	movl	$50, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	352(%rbp), %rdx
	movl	$0, %eax
	movl	$50, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	-48(%rbp), %rdx
	movl	$0, %eax
	movl	$50, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	.LC4(%rip), %rax
	movq	%rax, %rcx
	call	puts
	leaq	.LC5(%rip), %rax
	movq	%rax, %rcx
	call	printf
	leaq	1164(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rcx
	call	scanf
	leaq	.LC7(%rip), %rax
	movq	%rax, %rcx
	call	printf
	leaq	1156(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rcx
	call	scanf
	leaq	.LC8(%rip), %rax
	movq	%rax, %rcx
	call	puts
	movl	$0, 1180(%rbp)
	jmp	.L33
.L36:
	movl	$0, 1176(%rbp)
	jmp	.L34
.L35:
	leaq	752(%rbp), %rcx
	movl	1176(%rbp), %eax
	movslq	%eax, %r8
	movl	1180(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	addq	%r8, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rcx
	call	scanf
	addl	$1, 1176(%rbp)
.L34:
	movl	1156(%rbp), %eax
	cmpl	%eax, 1176(%rbp)
	jl	.L35
	addl	$1, 1180(%rbp)
.L33:
	movl	1164(%rbp), %eax
	cmpl	%eax, 1180(%rbp)
	jl	.L36
	leaq	.LC9(%rip), %rax
	movq	%rax, %rcx
	call	puts
	leaq	.LC5(%rip), %rax
	movq	%rax, %rcx
	call	printf
	leaq	1160(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rcx
	call	scanf
	leaq	.LC7(%rip), %rax
	movq	%rax, %rcx
	call	printf
	leaq	1152(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rcx
	call	scanf
	leaq	.LC10(%rip), %rax
	movq	%rax, %rcx
	call	puts
	movl	$0, 1172(%rbp)
	jmp	.L37
.L40:
	movl	$0, 1168(%rbp)
	jmp	.L38
.L39:
	leaq	352(%rbp), %rcx
	movl	1168(%rbp), %eax
	movslq	%eax, %r8
	movl	1172(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	salq	$2, %rax
	addq	%rdx, %rax
	addq	%rax, %rax
	addq	%r8, %rax
	salq	$2, %rax
	addq	%rcx, %rax
	movq	%rax, %rdx
	leaq	.LC6(%rip), %rax
	movq	%rax, %rcx
	call	scanf
	addl	$1, 1168(%rbp)
.L38:
	movl	1152(%rbp), %eax
	cmpl	%eax, 1168(%rbp)
	jl	.L39
	addl	$1, 1172(%rbp)
.L37:
	movl	1160(%rbp), %eax
	cmpl	%eax, 1172(%rbp)
	jl	.L40
	leaq	.LC11(%rip), %rax
	movq	%rax, %rcx
	call	puts
	leaq	-49(%rbp), %rax
	movq	%rax, %rdx
	leaq	.LC12(%rip), %rax
	movq	%rax, %rcx
	call	scanf
	movzbl	-49(%rbp), %eax
	movsbl	%al, %eax
	cmpl	$45, %eax
	je	.L41
	cmpl	$45, %eax
	jg	.L42
	cmpl	$42, %eax
	je	.L43
	cmpl	$43, %eax
	jne	.L42
	leaq	.LC13(%rip), %rax
	movq	%rax, %rcx
	call	puts
	movl	1152(%rbp), %r8d
	movl	1160(%rbp), %ecx
	movl	1156(%rbp), %r10d
	movl	1164(%rbp), %edx
	leaq	352(%rbp), %r11
	leaq	752(%rbp), %rax
	leaq	-48(%rbp), %r9
	movq	%r9, 48(%rsp)
	movl	%r8d, 40(%rsp)
	movl	%ecx, 32(%rsp)
	movq	%r11, %r9
	movl	%r10d, %r8d
	movq	%rax, %rcx
	call	add
	jmp	.L44
.L41:
	leaq	.LC14(%rip), %rax
	movq	%rax, %rcx
	call	puts
	movl	1152(%rbp), %r8d
	movl	1160(%rbp), %ecx
	movl	1156(%rbp), %r10d
	movl	1164(%rbp), %edx
	leaq	352(%rbp), %r11
	leaq	752(%rbp), %rax
	leaq	-48(%rbp), %r9
	movq	%r9, 48(%rsp)
	movl	%r8d, 40(%rsp)
	movl	%ecx, 32(%rsp)
	movq	%r11, %r9
	movl	%r10d, %r8d
	movq	%rax, %rcx
	call	sub
	jmp	.L44
.L43:
	leaq	.LC15(%rip), %rax
	movq	%rax, %rcx
	call	puts
	movl	1152(%rbp), %r8d
	movl	1160(%rbp), %ecx
	movl	1156(%rbp), %r10d
	movl	1164(%rbp), %edx
	leaq	352(%rbp), %r11
	leaq	752(%rbp), %rax
	leaq	-48(%rbp), %r9
	movq	%r9, 48(%rsp)
	movl	%r8d, 40(%rsp)
	movl	%ecx, 32(%rsp)
	movq	%r11, %r9
	movl	%r10d, %r8d
	movq	%rax, %rcx
	call	mul
	jmp	.L44
.L42:
	leaq	.LC16(%rip), %rax
	movq	%rax, %rcx
	call	puts
	nop
.L44:
	movl	$0, %eax
	addq	$1320, %rsp
	popq	%rdi
	popq	%rbp
	ret
	.seh_endproc
	.ident	"GCC: (MinGW-W64 x86_64-ucrt-posix-seh, built by Brecht Sanders) 11.3.0"
	.def	putchar;	.scl	2;	.type	32;	.endef
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	scanf;	.scl	2;	.type	32;	.endef
