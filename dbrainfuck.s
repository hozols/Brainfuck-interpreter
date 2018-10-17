.global main

format_str: .asciz "%c"
error: .asciz "Unrecognized character found"
format_decimal: .asciz "%d \n"
msg1: .asciz "\nFinished \n"
code: .asciz ">+++++++++[<++++++++>-]<.>+++++++[<++++>-]<+.+++++++..+++.>>>++++++++[<++++>-]<.>>>++++++++++[<+++++++++>-]<---.<<<<.+++.------.--------.>>+."
# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
code2: .asciz "++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++.>+.+++++++..+++.<<++.>+++++++++++++++.>.+++.------.--------.<<+.<."
main:

	call brainfuck

	call exit

brainfuck:

	movq $code, %rdi
	push %rbp
	movq %rsp, %rbp

	movq %rdi, %rsi
	subq $4000, %rbp
	movq $0, %r14

	movq $10000, %rax
	fillStack:
	cmpq $0, %rax
	je charLoop
	push $0
	subq $1, %rax
	jmp fillStack

	charLoop:

	lodsb 

	cmpq $0, %r14
	jg skipProcess

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

	// Opening lopp char
	cmpq $91, %rax
	je startLoop

	// Opening lopp char
	cmpq $93, %rax
	je endLoop

	skipProcess:

	// Opening lopp char
	cmpq $91, %rax
	je startLoopSkip

	// Opening lopp char
	cmpq $93, %rax
	je endLoopSkip



	jmp charLoop

	startLoopSkip:
	addq $1, %r14
	jmp charLoop

	endLoopSkip:
	subq $1, %r14
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

	startLoop:
	cmp $0, (%rbp)
	je skipLoop
	push %rsi
	push %rbp
	jmp charLoop
	skipLoop:
	movq $1, %r14
	jmp charLoop

	endLoop:

	cmp $0, (%rbp)
	jne completeLoopExecution
	pop %r15
	pop %r15
	jmp charLoop

	completeLoopExecution:
	pop %rsi
	pop %rsi
	subq $1, %rsi
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

	movq $10000, %rax
	emptyStack:
	cmpq $0, %rax
	je terminate
	pop %rbx
	subq $1, %rax
	jmp emptyStack


	terminate:
	//movq %rbp, %rsp
	popq %rbp
	ret
