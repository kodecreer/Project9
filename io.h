STDIN equ 0
STDOUT equ 1

; documented in syscalls.pdf
EXIT equ	1
READ equ	 3
WRITE equ 4
OPEN equ	 5
CLOSE equ	 6

; documented in fnctl.h, except that hex values are expressed as octal
RDONLY equ 0
WRONLY equ 1
RDWR equ	2
APPEND equ 8
RANDOM equ 10O
SEQUEN equ 2o
CREAT equ 100o
TRUNC equ 200o
