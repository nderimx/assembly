section .bss
    our_user_input resb 8

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, our_user_input
    mov edx, 8
    int 80h

    mov eax, 4
    mov ebx, 1
    mov ecx, our_user_input
    mov edx, 8
    int 80h

    mov eax, 1
    mov ebx, 0
    int 80h