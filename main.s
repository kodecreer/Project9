GLOBAL _start
    
section .data
    file_desc:
        dd 0
    r_desc:
        dd 0
    filename:
        db "visit.txt", 0
    err_open:
        db `failed to open file\n`,0
    err_close:
        db `failed to close file\n`,0
    marker:
        db $ - err_close
    remember:
        db `, is that right? That's what made you tough? y/n\n`,0
    greeting:
        db `Welcome to the Salty Spatoon how tough are you?\n`,0
    confirm:
        db `Well ain't that correct and tough? y/n\n`,0
    contractp:
        db `Well, I will put your testimony as a witness unto this weak generation\n`,0
    finalwordp:
        db `Go to weenie hut juniors weakling, you may say your last words.\n`,0
    weenie:
        db `I have written that down. Never come here again\n`,0
    gameover:
        db `I have written that down. Come in\n`,0
    golen equ $ - gameover

section .bss
    testimony:
        resb 1024
    confirmation:
        resb 2
    finalwords:
        resb 90
    read_buffer:
        resb 80


%include "io.h"
section .text 
_start:
    ;Part 1 -------------------------
    ;Greet the user about father's day
    call start_read
    mov eax, remember
    mov ebx, greeting - remember
    call print
    mov eax, confirmation
    call getline
    mov al, [confirmation]
    cmp al, 'y'
    je tough

    mov eax, greeting
    mov ebx, confirm - greeting
    call print
    ;Ask them to type a short message
    ;To leave for their dad

    call create_file
    mov eax, testimony
    call getline
    mov ecx, testimony
    call write_file
    ;Confirm if that is the name they want
    mov eax, confirm
    mov ebx, contractp - confirm
    call print

    mov eax, confirmation
    call getline
    ;Make sure you move it to al
    ;so you can compare and 8 bit
    ;char in comparison to a 32 bit
    mov al, [confirmation]
    cmp al, 'y'
    je tough
    ;otherwise send them to weenie hut juniors
    mov eax, finalwordp
    mov ebx, weenie - finalwordp
    call print
    mov eax, finalwords
    call getline
    mov ecx, finalwords
    call write_file

    mov eax, weenie
    mov ebx, gameover - weenie
    call print
    call close_write
    jmp exit
    ;Part 1 END --------------------
tough:
    ;write down the file of how tough
    ;someone is
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
create_file:
    mov ebx, filename
    mov ecx, WRONLY|CREAT
    mov edx, 666o
    mov eax, OPEN
    int 80h
    cmp eax, 0
    jle errOpen
    mov [file_desc], eax ;save file descriptor
    ret
;parameters
;ecx : The text to write

write_file:
    mov ebx, [file_desc]
    ;mov ecx, testimony
    mov edx, eax
    mov eax, WRITE
    int 80h

    cmp ebx, 0
    jl errWrite

    ret

close_write:
    mov ebx, [file_desc]
    mov eax, CLOSE
    int 80h
    jmp exit

errOpen:
    mov eax, err_open
    mov ebx, err_close - err_open
    call print
    jmp exit
errWrite:
    mov eax, err_close
    mov ebx, marker - err_close
    call print
    jmp exit
start_read:
    mov ebx, filename
    mov ecx, RDONLY
    mov eax, OPEN
    int 80h
    cmp eax, 0
    jl errOpen
    mov [r_desc], eax
again:
    mov ebx, [r_desc]
    mov ecx, read_buffer
    mov edx, 80 ;buffer size
    mov eax, READ
    int 80h
    cmp eax, 0 ;exit if we hit the null terminating zero
    jz close_read

    mov edx, eax ;transfer length of line
    mov ebx, STDOUT ;write to the screen
    mov ecx, read_buffer ;point to string to print
    mov eax, WRITE
    int 80h

    mov ebx, [r_desc]
    jmp again 
close_read:
    mov ebx, [r_desc]
    mov eax, CLOSE
    int 80h
    ret

