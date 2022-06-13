GLOBAL _start
    
section .data
    greeting:
        db `Welcome to the Salty Spatoon how tough are you?\n`,0
    confirm:
        db `Well ain't that correct? y/n\n`,0
    contractp:
        db `Well, I will put your testimony as a witness unto this weak generation\n`,0
    finalwords:
        db `Go to weenie hut juniors weakling, you may say your last words.\n`,0
    gameover:
        db `I have written that down. Come in`
section .bss
    testimony:
        resb 45
    finalwords:
        resb 45
section .text 
_start:
    ;Part 1 -------------------------
    ;Greet the user about father's day
    ;Ask them to type a short message
    ;To leave for their dad
    ;Confirm if that is the name they want
    ;otherwise have them try another message
    ;Part 1 END --------------------
