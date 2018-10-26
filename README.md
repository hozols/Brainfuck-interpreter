# Brainfuck

Current speed: 3.6 - 3.9s for hanoi

List of optimizations:

1. [-] sets directly the current cell to 0
2. 8 bit registers on most places
3. + and - merged into one register and moved to the memory in one go
4. > and < checks directly for next char if it's also a > or a < and executes shifting immediately (this operation is recursive e.g, the next shift operator also checks for the next one, etc.)
5. printf and scanf replaced with getchar and putchar
6. Order of ascii comparing optimized (+ AND - are checked first, as they are the most common operators, next shifters, etc..)


