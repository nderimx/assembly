# Assembly Tutorial

## x86
In the x86 part I've been taking notes by following the tutorialspoint.com/assembly_programming tutorial
## Compile
`nasm -f elf hello.asm`<br>
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

### General Registers

#### Data Registers
*Four* 32-bit Registers can be used in three ways:
1. 32-bit Registers: **EAX**, **EBX**, **ECX**, **EDX**.
2. Lower halves as 16-bit Registers: AX, BX, CX, DX
3. Either half of each 16-bit Register as 8-bit Registers: AH, AL, BH, BL, CH, CL, DH, DL

* AX - is used for accumulation - io & arithmetic instructructions
* BX - Base Register
* CX - Count Register - Stores loop count in iterations
* DX - Data Register - io ops & for some arithmetics used alogside AX

#### Pointer Registers
*Three* 32-bit Registers with their lower 16-bit halves (IP, SP, BP)
* **EIP** is the complete Address of current instruction = (CS:IP) CS Register in association with IP (*Instruction Pointer*, which stores the offset address of the next instrucion)
* **ESP** is the current Position of data or address within the porgram stack = (SS:SP) SS + SP (*Stack Pointer*, which stores the offset value within the program stack)
* **EBP** has the location of a parameter variable passed to a subroutine = (SS:BP; for special addressing DI:BP or SI:BP can also be used) SS* + BP (*Base Pointer* helps in referencing the parameter)

#### Index Registers
*Two* 32-bit Registers **ESI** and **EDI**. Each one has a 16-bit lower portion, *SI* and *DI*, which are used for indexed addressing and sometimes in addition and subtraction.
* *SI* Source Index - for string operations
* *DI* Destination Index - for string operations

### Control Registers
Made out of:
- Instruction Pointer Register & 32-bit Flags Register

Common Flag bits in Flags Register:
* Overflow Flag
* Direction Flag - 0 = Left to Right
* Interrupt Flag - allow interrupts
* Trap Flag - for debugging?
* Sign Flag - 0 = positive
* Zero Flag - 0 = non-zero result
* Auxiliary Carry Flag - carry from bit 3 to bit 4
* Parity Flag - total bits need to be even!?
* Carry Flag - carry of overflow bit OR last bit of rotate of shift operation

|Flag|  |   |   |   | O | D | I | T | S | Z |   | A |   | P |   | C |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|__Bit No.__|15|14|13|12|**11**|**10**|**9**|**8**|**7**|**6**|5|**4**|3|**2**|1|**0**|

### Segment Registers
* Code Segment - all instructions - 16-bit code segment register (CS Register) stores the starting address
* Data Segment - data, constants and work areas - DS Register stores starting address
* Stack Segment - data and return addresses of subroutines/procedures - SS Register stores starting address

Usually the exact location of an address is determined by combining the starting address of a sengment and the offset of the specific address.

## System Calls
6 Registers used as paramaters in Sys Calls:
* EBX
* ECX
* EDX
* ESI
* EDI
* EBP

### File Descriptor
0 - stdin   = STDIN_FILENO
1 - stdout  = STDOUT_FILENO
2 - stderr  = STDERR_FILENO

### System Exit
(?) `mov, ebx, 1` (?)<br>
`mov eax, 1 ; syscall number` __sys_exit__<br>
`int 0x80   ; call kernel`

### System Fork
`mov ebx, xxx ; struct pt_regs`<br>
`mov eax, 2   ; syscall number` __sys_fork__<br>
`int 0x80     ; call kernel`

### System Read
`mov edx, 6   ; input length / size_t`<br>
`mov ecx, xxx ; char* - variable to store user input`<br>
`mov ebx, 0   ; file descriptor`<br>
`mov eax, 3   ; syscall number` __sys_read__<br>
`int 0x80     ; call kernel`
### System Write
`mov edx, len ; msg length / size_t`<br>
`mov ecx, msg ; const char*`<br>
`mov ebx, 1   ; file descriptor`<br>
`mov eax, 4   ; syscall number` __sys_write__<br>
`int 0x80     ; call kernel`

`section	.data`<br>
`msg db 'Wabalaba dub dub!',0xa ; message`<br>
`len equ $-msg                  ; length of message`

### System Open
`mov edx, 0766   ; int - permissions`<br>
`mov ecx, file_access_mode   ; int`<br>
`mov ebx, filename ; const char*`<br>
`mov eax, 5  ; syscall number` __sys_open__<br>
`int 0x80   ; call kernel`

### System Close
`mov ebx, 1  ; file descriptor`<br>
`mov eax, 6  ; syscall number` __sys_close__<br>
`int 0x80   ; call kernel`

#### List with syscalls is in: /usr/include/asm*/unistd.h

#### POSIX - Portable OS Interface - (?) POSIX defines the API for syscalls, filedescriptors,... along with shells and utility interfaces for maintaining compatibility between OSes

## Addressing

3 Basic Modes of Addressing:
#### Register Addressing         - addresses or values inside registers
#### Immediate Addressing        - in-code hardcoded constants
#### Memory Addressing           - using addresses defined in data segment
* Direct Memory Addressing    - using addresses defined in data segment ^
* Direct Offset-Addressing    - using addresses of arrays defined in data segment
  * e.g. -v
    * `WORD_ARRAY DW 324, 643, 654, 113`
    * `MOV CX, WORD_ARRAY + 2` OR `MOV CX, WORD_ARRAY[2]` where WORD_ARRAY is the first address in the array, and 2 is the offset, or logically the 3rd address
* Indirect Memory Addressing  - basically assigning values to an array element
  * e.g. -v
    * `WORD_ARRAY TIMES 10 DW 0`
    * `MOV EBX, [MY_TABLE]` ; move the effective_address/pointer to EBX
    * `MOV [EBX], 110`  ; first element equals 110 (mannipulating the memory EBX points to)
    * `ADD EBX, 2`  ; offset by 2, so the current effective address points to the third element
    * `MOV [EBX], 123`  ; set third element to 123

### MOV
  MOV destination, source
  The two operands can be in any combination of the three addressing modes, except the destination operand cannot be an immediate address
  Both operands must be of the same size

#### Type Specifiers
* BYTE = 1B
* WORD = 2B
* DWORD = 4B
* QWORD = 8B
* TBYTE = 10B

e.g. -> `MOV	[name],  DWORD 'Nuha'` ; HERE we specified the type of immediate to avoid ambiguity

## Variables

### Allocating storage for initialized data
syntax: `var-name directive initial-val [,initial-val,...]`
#### Define Directives:
( **D** stands for Define and the second letter stands for the *Type Specifier*)
 **DB**, **DW**, **DD**, **DQ**, **DT**

#### Data Types
Processor uses little endian byte order
* Each byte character is stored as its ASCII value in HEX
* Each decimal is stored as 16-bits HEX (Find out whether its encoden in hamming or smth else)
* Negative decimals are converted to its 2-complement
* Short floats are stored in 32-bits
* Long floats are stored in 64-bits

### Allocating storage for uninitialized data
Basically declaring vars vithout initializing them
#### Reserve directives are used:
 **RESB**, **RESW**, **RESD**, **RESQ**, **REST**

### Initializing arrays / multi-inits
`books  TIMES  9  DW  0` - this is an array of length 9 with all elements initialized to 0

## Constants
### Directives
* EQU (e.g. `SYS_WRITE EQU 4`)
* %assign - for numbers; redefinable; e.g. `%assign GRAV 10`, `%assign GRAV 20`
* %define - for numbers & strings; redefinable; e.g. `%define PTR [EBP+3]`

## Arithmetic Instructions
### INC - increment
Syntax -> `INC destination`<br>
Examples:<br>
`INC EBX`<br>
`INC [count]`<br>
`INC DH`
### DEC - decrement
Examples:
`DEC [eta]`<br>
`DEC byte [ESI]`

### ADD & SUB - add & subtract
Syntax -> `ADD/SUB destination, source`<br>
***You cannot use momory-to-memory addition or substraction***
*ADD or SUB operations set or clear the overflow and carry flags*
#### !Before using a number from sys_read, first subtract ascii '0' from it, to convert it into a decimal number!
#### To convert a decimal to ASCII, for sys_write, add '0' to it

### MUL/IMUL - Unsigned Multiply / Integer Multiply
Both affect the Carry and Overflow Flags<br>
Syntax -> `MUL/IMUL multiplier`<br>
The multiplicant is defined in **AL**, **AX** , or **EAX** before the MUL/IMUL instruction
Depending if the result fits in the multiplicant register or not, the result gets stored in its multiplicant register, or in `AH` `AL`, `DX` `AX`, or `EDX` `EAX` 

### DIV/IDIV - Unsigned Multiply / Integer Multiply
Generates 2 outputs: **Quotient** and **Remainder**
The processor generates an interrupt if overflow occurs
Syntax -> `DIV/IDIV divisor`
The operation affects 6 status flags... dunno which ones

Examples:
1. `AX`16bit divident / 8bit divisor -> `AL`quotient & `AH`remainder
2. `DX``AX`32bit divident / 16bit divisor -> `AX`quotient & `DX`remainder
3. `EDX``EAX`64bit divident / 32bit divisor -> `EAX`quotient & `EDX`remainder

## Logical Instructions
* AND
* OR
* XOR
* TEST
* NOT - has only one operand
*memory-to-memory ops aren't possible*
These instructions set the **CF**, **OF**, **PF**, **SF** and **ZF** flags
 ### AND
 ##### if the lowest bit is 1 the zero flag is set to 1, otherwise its set to 0
 Tricks:
1. assuming BL contains 0011 1010, if you want to clear the high-order bits to zero, you AND with 0FH<br>
    `AND BL, 0FH`
2. check if odd/even:<br>
  `AND AL, 01H`<br>
  `JZ EVEN_NUMBER`

### Code Memory Addresses / Labels

Labels are in the same indentation as `_start:` (in other words, without any intentation) and denote a specific memory address within the code segment. Jumping to a location using a label, points the instruction pointer to the first insctruction inside of its code block.

### OR

Can be used to fill parts of a register with 1s.

### XOR

XORing a register with itself clears it to 0 (I assume using XOR & AND to clear rewgisters is more efficient than moving 0 into them)

### TEST

Same as AND, but does **not** change the first operand.
Perfect for checking if a number is even.

### NOT

Reverses all bits of the operand

##Conditions

* Unconditrional Jump - JMP
* Conditional Jump - j&lt;condition>

### CMP - Compare

Subtracts two operands without changing any of them, and sets: zero_flag and sign_flag (i think) (for gt, lt) appropriately.

### Handy Instructions - SHL - Shift Left

Shifts all bits inside a given operand to the left, effectively doubling it.

### Conditional Jump

* JE/ JZ    - ZF        - JUMP Equal OR JUMP Zero
* JNE/JNZ   - ZF        - JUMP not Equal OR  JUMP not Zero

For signed data and arithmetic operations

* JG/JNLE   - OF,SF,ZF  - JUMP Greater OR JUMP not Less/Equal
* JGE/JNL   - OF,SF     - JUMP Greater/Equal OR JUMP not Less
* JL/JNGE   - OF,SF     - JUMP Less OR JUMP not Greater/Equal
* JLE/JNG   - OF,ZF,SF  - JUMP Less/Equal OR JUMP not Greater

For unsigned data and logical operations

* JA/JNBE   - CF,ZF - JUMP Above
* JAE/JNB   - CF    - JUMP not Below
* JB/JNAE   - CF    - JUMP Below
* JBE/JNA   - AF,CF - JUMP not Above
  
For special uses and check specific flags

* JXCZ      -noFLAGS- JUMP CX is Zero
* JC        - CF    - JUMP if Carry
* JNC       - CF    - JUMP if not Carry
* JO        - OF    - JUMP if Overflow
* JNO       - OF    - JUMP if not Overflow
* JP/JPE    - PF    - JUMP if parity / parity equal
* JNP/JPO   - PF    - JUMP if not parity / parity odd
* JS        - SF    - JUMP if sign / negative value
* JNS       - SF    - JUMP if not sign / positive value

## Loops

`mov cl, 10`<br>
`L1:`<br>
`DEC CL`<br>
`JNZ L1`

EQUALS

`MOV ECX, 10`<br>
`L1:`<br>
`LOOP L1`

LOOP decrements ECX and jumps if its not zero. Not sure if it actually checks the ZF.

## Numbers

#### 2 Representations ins ASM:

* ASCII
* BSD

### ASCII Representation

You can do arithmetics on ASCII numbers, then perform either:<br>
ASCII Adjust After -
* AAA - Addition
* AAS - Subtraction
* AAM - Multiplication

or before performing arithmetics, fisrt ASCII Adjust Before -
* ABD - Division

Then OR-ing the result with 0x30

### BCD Representation

* Unpacked
* Packed

#### Unpacked BCD

Each byte stores one decimal digit

Example: 1234 -> `01 02 03 04H`

The same Adjust instructions can be used as for ASCII

#### Packed BCD

Each byte stores two decimal digits

Example 1234 -> `12 34H`

There is no support for multiplication/division.

For processing these numbers these instructions are used:
* DDA - Decimal Adjust After Addition
* DAS - Decimal Adjust After Subtraction

### Revisit the last code Example in the original tutorial

## Strings

2 ways of storing strings:
* also storing string length
* using a sentinel character

### **$** points to the byte after the given variable.
Example: `$-msg` gives you the length of the variable *msg*.

### String Instructions

They have either a source operand, destination operand or both.
* ESI -> source     |   DS:SI       |   SI for 16bit
* EDI -> destination    |   ES:DI       | DI for 16bit

#### 5 Instructions:

* MOVS - moves a B, W, or DW
* LODS - loads a B, W, or DW from memory
* STOS - stores from register to memory
* CMPS - compares two items in memory
* SCAS - compares contet of a register with an item in memory

### Repitition Prefixes

**REP** prefix with a string instction after, repeats that instruction based on the counter in the CX register.

#### Direction Flag (DF)

* CLD instruction - operation goes left ot right - Clear Direction
* STD instruction - operation goes right to left - Set Direction

##### REP Variations:

* REPE or REPZ - also depends on ZF=0
* REPNE or REPNZ - also depends on ZF=1
* REP - depends only on CX

## Arrays

### Declaration
`NUMBERS DW 32, 61, 26, 84`<br>
*or*<br>
`NUMBERS DW 32`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DW 61`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DW 26`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DW 84`

*or*<br>
`NUMBERS:`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DW 32`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DW 61`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DW 26`<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`DW 84`

In this example array we have 4 Word elements with a total of 8 bytes. Since it's 2 bytes per element: the second element is NUMBER+2, the third one is NUBMER+4, ... and so on.

## Procedures

Syntax:<br>
`proc_name:`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`procedure body`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`...`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`ret`

`CALL proc_name`

#### SUM PROCEDURE Example
`sum: ; adds ECX & EDX into EAX`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`MOV EAX, ECX`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`ADD, EAX, EDX`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`ADD EAX, '0'`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`ret`<br>

### Stacks

Instructions:

`PUSH <operand>`<br>
`POP <address/register>`

Registers:

* SS - beginning of the stack segment
* ESP (or SP) - offset into the stack segment
  
SS:ESP points to the top of the stack

#### Stack Implementation Characgteristics:
* Elements can be only **words** or **doublewords**
* Stack grows towards the lower memory addresses
* Top points to lower byte of last word inserted

## Recursion
  
* Direct - when procedure calls itself
* Indirect - when procedure A calls procedure B, and B calls A
  
## Macros

*Macros are defined above the text section (?)*

Syntax:<br>
`%macro macro_name number_or_parameters`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`<macro body>`<br>
`%endmacro`

Example:<br>

`%macro write_string 2`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`MOV EAX, 4`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`MOV EBX, 1`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`MOV ECX, %1`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`MOV EDX, %2`<br>
&nbsp;&nbsp;&nbsp;&nbsp;`INT 0x80`<br>
`%endmacro`

`write_string msg, len`

## File Management

### File Pointer

Is the location of a byte (used while reading/writing) inside of a file.<br>
It points to the offset of a byte relative to the beginning of the file. -> first byte of a file has a filepointer set to 0.<br>
Each open file has its own filepointer.

### More file handling sys_calls

#### SYS_CREATE

`MOV EBX, name ; const char*`<br>
`MOV ECX, permissions ; int`<br>
`MOV EAX, 8 ; syscall number`

### SYS_LSEEK

`MOV EBX, filedescriptor ; unsigned int`<br>
`MOV ECX, filepointer ; off_t - offset`<br>
`MOV EAX, 19 ; syscall number`<br>
`MOV EDX, reference_position ; unsigned int`

### File Descriptor

When creating or opening a file, a file descriptor is stored in the EAX Register. That file descriptor is used in sys_write, sys_read and sys_lseek to access a file.

## Memory Management

sys_brk() is used to allocate/reserve memory.

Example (16kB): <br>
`MOV EAX, 45 ; sys_brk`<br>
`XOR EBX, EBX ; clear EBX`<br>
`INT 80h`

`ADD EAX, 16384`<br>
`MOV EBX, EAX ; highest memory address in allocation`<br>
`MOV EAX, 45 ; syscall nubmer sys_brk`<br>
`int 0x80`

If there is an error, a negative code is returned in EAX.
