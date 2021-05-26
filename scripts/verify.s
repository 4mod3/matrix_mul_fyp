	.file	"verify.c"
	.text
	.globl	_Z20ConvertNumberToFloatmi
	.type	_Z20ConvertNumberToFloatmi, @function
_Z20ConvertNumberToFloatmi:
.LFB954:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movq	%rdi, -72(%rbp)
	movl	%esi, -76(%rbp)
	cmpl	$0, -76(%rbp)
	je	.L2
	movl	$52, %eax
	jmp	.L3
.L2:
	movl	$23, %eax
.L3:
	movl	%eax, -48(%rbp)
	cmpl	$0, -76(%rbp)
	je	.L4
	movabsq	$9218868437227405312, %rax
	jmp	.L5
.L4:
	movl	$2139095040, %eax
.L5:
	movq	%rax, -16(%rbp)
	cmpl	$0, -76(%rbp)
	je	.L6
	movl	$1023, %eax
	jmp	.L7
.L6:
	movl	$127, %eax
.L7:
	movl	%eax, -44(%rbp)
	cmpl	$0, -76(%rbp)
	je	.L8
	movl	$63, %eax
	jmp	.L9
.L8:
	movl	$31, %eax
.L9:
	movl	%eax, -40(%rbp)
	movl	-40(%rbp), %eax
	movq	-72(%rbp), %rdx
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	andl	$1, %eax
	movl	%eax, -36(%rbp)
	movq	-72(%rbp), %rax
	andq	-16(%rbp), %rax
	movq	%rax, %rdx
	movl	-48(%rbp), %eax
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	movl	-44(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -32(%rbp)
	movl	$-1, -56(%rbp)
	pxor	%xmm0, %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	$0, -52(%rbp)
	jmp	.L10
.L11:
	movl	-48(%rbp), %eax
	subl	-52(%rbp), %eax
	subl	$1, %eax
	movq	-72(%rbp), %rdx
	movl	%eax, %ecx
	shrq	%cl, %rdx
	movq	%rdx, %rax
	andl	$1, %eax
	movl	%eax, -28(%rbp)
	pxor	%xmm3, %xmm3
	cvtsi2sdl	-28(%rbp), %xmm3
	movsd	%xmm3, -88(%rbp)
	movl	-56(%rbp), %edx
	movq	.LC1(%rip), %rax
	movl	%edx, %edi
	movq	%rax, %xmm0
	call	_ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_
	mulsd	-88(%rbp), %xmm0
	movsd	-24(%rbp), %xmm1
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -24(%rbp)
	subl	$1, -56(%rbp)
	addl	$1, -52(%rbp)
.L10:
	movl	-52(%rbp), %eax
	cmpl	-48(%rbp), %eax
	jl	.L11
	cmpl	$0, -36(%rbp)
	je	.L12
	movsd	.LC2(%rip), %xmm4
	movsd	%xmm4, -88(%rbp)
	jmp	.L13
.L12:
	movsd	.LC3(%rip), %xmm5
	movsd	%xmm5, -88(%rbp)
.L13:
	movl	-32(%rbp), %edx
	movq	.LC1(%rip), %rax
	movl	%edx, %edi
	movq	%rax, %xmm0
	call	_ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_
	movsd	-88(%rbp), %xmm1
	mulsd	%xmm0, %xmm1
	movsd	-24(%rbp), %xmm2
	movsd	.LC3(%rip), %xmm0
	addsd	%xmm2, %xmm0
	mulsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	movsd	-8(%rbp), %xmm0
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE954:
	.size	_Z20ConvertNumberToFloatmi, .-_Z20ConvertNumberToFloatmi
	.section	.rodata
.LC4:
	.string	"%016lX\n%016lx"
	.text
	.globl	main
	.type	main, @function
main:
.LFB955:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movabsq	$4595810714834216644, %rax
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	_Z20ConvertNumberToFloatmi
	movq	%xmm0, %rax
	movq	%rax, -56(%rbp)
	movabsq	$4600035720442928768, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	_Z20ConvertNumberToFloatmi
	movq	%xmm0, %rax
	movq	%rax, -40(%rbp)
	movabsq	$4604911288216064575, %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	_Z20ConvertNumberToFloatmi
	movq	%xmm0, %rax
	movq	%rax, -24(%rbp)
	movsd	-56(%rbp), %xmm0
	mulsd	-40(%rbp), %xmm0
	movsd	%xmm0, -16(%rbp)
	movsd	-16(%rbp), %xmm0
	addsd	-24(%rbp), %xmm0
	movsd	%xmm0, -80(%rbp)
	movsd	-24(%rbp), %xmm1
	movsd	-40(%rbp), %xmm0
	movq	-56(%rbp), %rax
	movapd	%xmm1, %xmm2
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	fma@PLT
	movq	%xmm0, %rax
	movq	%rax, -72(%rbp)
	leaq	-72(%rbp), %rax
	movq	(%rax), %rdx
	leaq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rsi
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L17
	call	__stack_chk_fail@PLT
.L17:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE955:
	.size	main, .-main
	.section	.text._ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_,"axG",@progbits,_ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_,comdat
	.weak	_ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_
	.type	_ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_, @function
_ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_:
.LFB1007:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movsd	%xmm0, -8(%rbp)
	movl	%edi, -12(%rbp)
	pxor	%xmm0, %xmm0
	cvtsi2sdl	-12(%rbp), %xmm0
	movq	-8(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, %xmm0
	call	pow@PLT
	movq	%xmm0, %rax
	movq	%rax, %xmm0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1007:
	.size	_ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_, .-_ZSt3powIdiEN9__gnu_cxx11__promote_2IT_T0_NS0_9__promoteIS2_XsrSt12__is_integerIS2_E7__valueEE6__typeENS4_IS3_XsrS5_IS3_E7__valueEE6__typeEE6__typeES2_S3_
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1073741824
	.align 8
.LC2:
	.long	0
	.long	-1074790400
	.align 8
.LC3:
	.long	0
	.long	1072693248
	.ident	"GCC: (GNU) 11.1.0"
	.section	.note.GNU-stack,"",@progbits
