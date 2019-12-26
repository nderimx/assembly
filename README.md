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
(?) `mov, ebx, 1` (?)
`mov eax, 1 ; syscall number` __sys_exit__
`int 0x80   ; call kernel`

### System Fork
`mov ebx, xxx ; struct pt_regs`
`mov eax, 2   ; syscall number` __sys_fork__
`int 0x80     ; call kernel`

### System Read
`mov edx, 6   ; input length / size_t`
`mov ecx, xxx ; char* - variable to store user input`
`mov ebx, 0   ; file descriptor`
`mov eax, 3   ; syscall number` __sys_read__
`int 0x80     ; call kernel`

### System Write
`mov edx, len ; msg length / size_t`
`mov ecx, msg ; const char*`
`mov ebx, 1   ; file descriptor`
`mov eax, 4   ; syscall number` __sys_write__
`int 0x80     ; call kernel`

`section	.data`
`msg db 'Wabalaba dub dub!',0xa ; message`
`len equ $-msg                  ; length of message`

### System Open
`mov edx, 6   ; int`
`mov ecx, 5   ; int`
`mov ebx, xxx ; const char*`
`mov eax, 5  ; syscall number` __sys_open__
`int 0x80   ; call kernel`

### System Close
`mov ebx, 1  ; file descriptor`
`mov eax, 6  ; syscall number` __sys_close__
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

### get from laptop uncommited content

## Constants
### Directives
* EQU (e.g. `SYS_WRITE EQU 4`)
* %assign - for numbers; redefinable; e.g. `%assign GRAV 10`, `%assign GRAV 20`
* %define - for numbers & strings; redefinable; e.g. `%define PTR [EBP+3]`

## Arithmetic Instructions
### INC - increment
Syntax -> `INC destination`
Examples:
`INC EBX`
`INC [count]`
`INC DH`
### DEC - decrement
Examples:
`DEC [eta]`
`DEC byte [ESI]`

### ADD & SUB - add & subtract
Syntax -> `ADD/SUB destination, source`
***You cannot use momory-to-memory addition or substraction***
*ADD or SUB operations set or clear the overflow and carry flags*
#### !Before using a number from sys_read, first subtract ascii '0' from it, to convert it into a decimal number!
#### To convert a decimal to ASCII, for sys_write, add '0' to it

### MUL/IMUL - Unsigned Multiply / Integer Multiply
Both affect the Carry and Overflow Flags
Syntax -> `MUL/IMUL multiplier`
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
 Tricks:
 1. assuming BL contains 0011 1010, if you want to clear the high-order bits to zero, you AND with 0FH
   `AND BL, 0FH`
