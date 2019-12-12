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
* ACX
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

### List with syscalls is in: /usr/include/asm*/unistd.h

### POSIX - Portable OS Interface - (?) POSIX defines the API for syscalls, filedescriptors,... along with shells and utility interfaces for maintaining compatibility between OSes

