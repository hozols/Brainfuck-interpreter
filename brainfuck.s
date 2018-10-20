// Assignment 6
// Team member 1: Herman Ozols - 4929179
// Team member 2: Radoslav Stefanov - 4914244
// Copyright 2018 TU DELFT Computer Organization Course
// All rights reserved :)

.global brainfuck
//Fromat for putchar
format_str: .asciz "%c"
msg1: .asciz "\nFinished \n"
# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.

brainfuck:
	//Intizializing the stack
	push %rbp
	movq %rsp, %rbp
	//Move base pointer to r13 for later use
	movq %rbp, %r13

	movq %rdi, %rsi
	//Substract from base pointer so the base pointer is in the middle of th estack and so cels can go to left
	subq $40000, %rbp
	movb $0, %ah

	movq $10000, %rax
	fillStack:
	cmpq $0, %rax
	je charLoop
	push $0
	subq $1, %rax
	jmp fillStack
	//Reads the brainfuck input file char by char and acts acordingly
	charLoop:
	//Loads the next byte in %rax
	lodsb 

	cmpb $0, %ah
	jg skipProcess

	cmpb $0, %al
	je finish

	// Shift one place to the right
	cmpb $62, %al
	je shiftRight

	// Shift one place to the left
	cmpb $60, %al
	je shiftLeft

	// Substract one from the current cell
	cmpb $45, %al
	je substractOne

	// Add one from the current cell
	cmpb $43, %al
	je addOne

	// Print current cell
	cmpb $46, %al
	je printCell

	// Opening lopp char
	cmpb $91, %al
	je startLoop

	// Opening lopp char
	cmpb $93, %al
	je endLoop

	skipProcess:

	// Opening lopp char
	cmpb $91, %al
	je startLoopSkip

	// Opening lopp char
	cmpb $93, %al
	je endLoopSkip


	//Jumps back to read next byte
	jmp charLoop


	startLoopSkip:
	addb $1, %ah
	jmp charLoop

	endLoopSkip:
	subb $1, %ah
	jmp charLoop

	//Loop shifts cell to right
	shiftRight:
	subq $8, %rbp
	jmp charLoop

	//Loop shifts cell to left
	shiftLeft:
	addq $8, %rbp
	jmp charLoop

	//Adds one to current cell
	addOne:
	addq $1, (%rbp)
	jmp charLoop

	//Substracts one from current cell
	substractOne:
	subq $1, (%rbp)
	jmp charLoop

	//Starts the loop
	startLoop:
	cmp $0, (%rbp)
	je skipLoop
	push %rsi
	push %rbp
	jmp charLoop

	skipLoop:
	movb $1, %ah
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

	//Prints the cell and jumps back to charLoop
	printCell:

	push %rsi

	movq (%rbp), %rdi
	call putchar

	pop %rsi

	jmp charLoop

	//Zeroes rax and prints "Finished"
	finish:
	movq $0, %rax
	movq $msg1, %rdi
	call printf

	movq $10000, %rax
	emptyStack:
	movq %r13, %rsp
	// cmpq $0, %rax
	// je terminate
	// pop %rbx
	// subq $1, %rax
	// jmp emptyStack

	//Clears the stack
	terminate:
	//movq %rbp, %rsp
	popq %rbp
	ret
