.global main

format_str: .asciz "%c"
error: .asciz "Unrecognized character found"
format_decimal: .asciz "%d \n"
msg1: .asciz "\nFinished \n"
code: .asciz "+++++++[-]."
# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
code2: .asciz "++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++.>+.+++++++..+++.<<++.>+++++++++++++++.>.+++.------.--------.<<+.<."
main:

	movq $5, %r13
	movq $4, %r14
	movq $3, %r15
	call brainfuck

	call exit

brainfuck:

	movq $code, %rdi
	
	//Intizializing the stack
	push %rbp

	// Preserve r13, r14 and r15 values 
	push %r15
	push %r14
	push %r13

	movq %rsp, %rbp

	//Move base pointer to r13 for emptying the stack later
	movq %rbp, %r13

	// Pass the brainfuck string to rsi for loadsb to read it
	movq %rdi, %rsi

	// Set r14 to - this register will be used for tracking unexecuted while loops
	movq $0, %r14

	//Substract from base pointer so the base pointer is in the middle of th estack and so cels can go to left
	subq $400, %rbp

	// add 10 000 elements in the stack to use them as data storage for brainfuck array
	movq $3000, %rax
	fillStack:
	cmpq $0, %rax
	je charLoop
	pushw $0
	subq $1, %rax
	jmp fillStack

	//Reads the brainfuck input file char by char and acts acordingly
	charLoop:

	//Loads the next byte in %rax
	lodsb

	// Skips code execution if currently we are "skipping operations" due to unexecuted array
	cmpq $0, %r14
	jg skipProcess

	// Finishes code execution if ascii code is 0 (end of string)
	cmpq $0, %rax
	je finish

	// Shift one cell to the right
	cmpq $62, %rax
	je shiftRight

	// Shift one cell to the left
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

	// Closing lopp char
	cmpq $93, %rax
	je endLoop

	// Getchar
	cmpq $44, %rax
	je readUserInput

	// Listen for opening array tags and closing tags when skipping execution commands
	skipProcess:

	//Opening lopp char
	cmpq $91, %rax
	je startLoopSkip

	//Closing lopp char
	cmpq $93, %rax
	je endLoopSkip


	//Jumps back to read next byte
	jmp charLoop

	// Add 1 to r14 to keep track of opening tags
	startLoopSkip:
	addq $1, %r14
	jmp charLoop

	// Substract 1 from r14, if r14 is 0 normal execution will continue
	endLoopSkip:
	subq $1, %r14
	jmp charLoop

	// Loop shifts cell to right (substract 8 to rbp)
	shiftRight:
	subq $4, %rbp
	jmp charLoop

	// Loop shifts cell to left (addd 8 to rbp)
	shiftLeft:
	addq $4, %rbp
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
	// Check if current data cell is 0, if so, skip while loop execution
	cmp $0, (%rbp)
	je skipLoop

	// Push rsi to know at which point of the code to return when closing while tag is reached
	cmpb $45, (%rsi)
	jne continueStartLoop

	cmpb $93, 1(%rsi)
	jne continueStartLoop

	movq $0, (%rbp)
	addq $2, %rsi

	jmp charLoop


	continueStartLoop:
	push %rsi
	jmp charLoop

	skipLoop:
	// Set r14 to 1 - this will stop execution of next commands until according closing tag is reached (r14 is 0)
	movq $1, %r14
	jmp charLoop

	// Ends loop
	endLoop:

	// If current cell is 0, continue with next brainfuck command
	cmp $0, (%rbp)
	jne completeLoopExecution
	// Clean the stack; r15 is not used
	pop %r15
	jmp charLoop

	// If current cell is not 0, pop rsi (rsi being the pushed rsi from the opening while loop) and execute loop again
	completeLoopExecution:
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

	readUserInput:

	push %rsi

	call getchar
	movq %rax, (%rbp)

	pop %rsi

	jmp charLoop


	//Zeroes rax and prints "Finished"
	finish:
	movq $0, %rax
	movq $msg1, %rdi
	call printf

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

	pop %r13
	pop %r14
	pop %r15
	popq %rbp
	
	ret
