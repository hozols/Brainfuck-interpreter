.global brainfuck

format_str: .asciz "%c"
msg1: .asciz "\nFinished \n"
# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
brainfuck:
	pushq %rbp
	movq %rsp, %rbp

	movq $0, %rax
	movq %rdi, %rsi

	push $0
	push $0
	push $0
	push $0
	push $0
	push $0
	push $0
	push $0
	push $0

	subq $8, %rbp

	charLoop:

	lodsb 

	cmpq $0, %rax
	je finish

	// Shift one place to the right
	cmpq $62, %rax
	je shiftRight

	// Shift one place to the left
	cmpq $60, %rax
	je shiftLeft

	// Substract one from the current cell
	cmpq $45, %rax
	je substractOne

	// Add one from the current cell
	cmpq $43, %rax
	je addOne

	// Print current cell
	cmpq $46, %rax
	je printCell

	// pushq %rsi

	// movq %rax, %rsi
	// movq $0, %rax
	// movq $format_str, %rdi
	// call printf
	

	// popq %rsi

	jmp charLoop

	shiftRight: 
	subq $8, %rbp
	jmp charLoop

	shiftLeft: 
	addq $8, %rbp
	jmp charLoop

	addOne:
	addq $1, (%rbp)
	jmp charLoop

	substractOne:
	subq $1, (%rbp)
	jmp charLoop

	printCell:

	pushq %rsi
	
	movq (%rbp), %rsi
	movq $0, %rax
	movq $format_str, %rdi
	call printf

	popq %rsi

	jmp charLoop

	finish:

	movq $0, %rax
	movq $msg1, %rdi
	call printf

	popq %rax
	popq %rax
	popq %rax
	popq %rax
	popq %rax
	popq %rax
	popq %rax
	popq %rax
	popq %rax

	//movq %rbp, %rsp
	popq %rbp
	ret
