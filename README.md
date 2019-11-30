# Assembly Tutorial

## Compile
`nasm -f elf hello.asm`
`ld -m elf_i386 -s -o hello hello.o`

## ASM Sections
* .text - Code
* .data - Declare && Set Constants
* .bss  - Declare Variable Placeholders

## Memory Segments
* Data segment  - (.data & .bss)
* Code segment  - (.text)
* Stack         - contains data values passed to functions & procedures within the program

