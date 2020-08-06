# Makefuck
Brainfuck interpreter written in makefile.

The program is inserted by passing `PROG` to make, either as environment variable or like `make PROG="+ + +"`. Note: Instructions must be delimited by spaces.
The initial tape is specified by the `MEM` variable. The value of a cell is determined based on a sequence of dots: The cell value is `number_of_dots - 1`. Each cell must be delimited by spaces.
Input is passed to the program via `read`, which prompts for a character input. This is the only part that is not pure make, as output is written to a string and printed upon termination.
