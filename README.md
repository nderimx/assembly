# Assembly Tutorial

## x86
In the x86 part I've been taking notes by following the tutorialspoint.com/assembly_programming tutorial
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

## Registers
In IA-32 arch. there are **ten** 32-bit and **six** 16-bit Registers
* [General Registers](#general-registers)
  * [Data](#data-registers)
  * [Pointer](#pointer-registers)
  * [Index](#index-registers)
* [Control Registers](#control-registers)
* [Segment Registers](#segment-registers)

## General Registers

### Data Registers
*Four* 32-bit Registers can be used in three ways:
1. 32-bit Registers: **EAX**, **EBX**, **ECX**, **EDX**.
2. Lower halves as 16-bit Registers: AX, BX, CX, DX
3. Either half of each 16-bit Register as 8-bit Registers: AH, AL, BH, BL, CH, CL, DH, DL

* AX - is used for accumulation - io & arithmetic instructructions
* BX - Base Register
* CX - Count Register - Stores loop count in iterations
* DX - Data Register - io ops & for some arithmetics used alogside AX

### Pointer Registers
*Three* 32-bit Registers with their lower 16-bit halves (IP, SP, BP)
* **EIP** is the complete Address of current instruction = (CS:IP) CS Register in association with IP (*Instruction Pointer*, which stores the offset address of the next instrucion)
* **ESP** is the current Position of data or address within the porgram stack = (SS:SP) SS + SP (*Stack Pointer*, which stores the offset value within the program stack)
* **EBP** has the location of a parameter variable passed to a subroutine = (SS:BP; for special addressing DI:BP or SI:BP can also be used) SS* + BP (*Base Pointer* helps in referencing the parameter)

### Index Registers
*Two* 32-bit Registers **ESI** and **EDI**. Each one has a 16-bit lower portion, *SI* and *DI*, which are used for indexed addressing and sometimes in addition and subtraction.
* *SI* Source Index - for string operations
* *DI* Destination Index - for string operations

## Control Registers