; masm16

data segment
    welcomeMessage db 'Hello BJUT x86 MASM assembly programming!', '$' ;welcome message
    inputBuffer db 0ffh, ?, 0ffh dup(?), '$' ;input buffer
data ends

stack segment para stack
    db 100h dup(0)
stack ends

code segment
    assume cs: code, ds: data, ss: stack
start:
    mov ax, data ;init
    mov ds, ax

    lea dx, welcomeMessage ;prompt
    call WriteString

    call Crlf ;enter

    lea dx, inputBuffer ;read string
    call ReadString

    call Crlf ;enter

    lea dx, inputBuffer + 2 ;append $ to the end of string
    add dl, [inputBuffer + 1]
    call EndString

    lea dx, inputBuffer + 2 ;echo the string
    call WriteString

    call Crlf ;enter

    call ReadChar; read a character

    push ax ;save al
    call Crlf ;enter
    pop ax ;restore al
    mov dl, al ;move al to dl for writing
    call WriteChar ;write a character

    call Terminate ;terminate the program

include common.asm

code ends

    end start
