GLOBAL _start
    
section .data
    greeting:
        db `Welcome to the Salty Spatoon how tough are you?\n`,0
    confirm:
        db `Well ain't that correct? y/n\n`,0
    contractp:
        db `Well, I will put your testimony as a witness unto this weak generation\n`,0
    finalwordp:
        db `Go to weenie hut juniors weakling, you may say your last words.\n`,0
    weenie:
        db `I have written that down. Never come here again\n`,0
    gameover:
        db `I have written that down. Come in\n`,0
    golen .equ $ - gameover
section .bss
    testimony:
        resb 45
    confirmation:
        resb 10
    finalwords:
        resb 45

%include "io.h"
section .text 
_start:
    ;Part 1 -------------------------
    ;Greet the user about father's day
    mov eax, greeting
    mov ebx, confirm - greeting
    call print
    ;Ask them to type a short message
    ;To leave for their dad
    mov eax, testimony
    call getline
    ;Confirm if that is the name they want
    mov eax, confirm
    mov ebx, contractp - confirm
    call print

    mov eax, confirmation
    call getline
    cmp ecx, 121
    jz tough
    ;otherwise send them to weenie hut juniors
    mov eax, finalwordp
    mov ebx, weenie - finalwordp
    call print
    mov eax, finalwords
    call getline

    mov eax, weenie
    mov ebx, gameover - weenie
    call print
    jmp exit
    ;Part 1 END --------------------
tough:
    mov eax, gameover
    mov ebx, golen
    call print
    jmp exit
exit:
    mov eax, EXIT
    mov ebx, 0
    int 80h
print:
    push ebp
    mov ebp, esp

    mov ecx, eax
    mov edx, ebx
    mov eax, WRITE
    mov ebx, STDOUT
    int 80h
    
    mov esp, ebp
    pop ebp

    ret

getline:
    push ebp
    mov ebp, esp
    
    mov ecx, eax
    mov eax, READ
    mov ebx, STDIN
    int 80h

    mov esp, ebp
    pop ebp
    ret