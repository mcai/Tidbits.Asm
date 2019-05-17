; masm for DOS (16 bit) programming using simplified segment definition
title Hello

.model small
.stack 100h

.data
    welcomeMessage db 'Hello BJUT x86 MASM assembly programming!', '$' ;welcome message
    inputBuffer db 0ffh, ?, 0ffh dup(?), '$' ;input buffer

.code
start:
    mov ax, @data ;init
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

;    push al ;save al
;    call Crlf ;enter
;    pop al ;restore al
    mov dl, al ;move al to dl for writing

    call WriteChar ;write a character

    call Terminate ;terminate the program


; Append $ to end of the string
EndString proc
    mov bx, dx
    mov byte ptr [bx], '$'
    ret
EndString endp


; Read a character from standard input and put in al
ReadChar proc
    mov ah, 01h
    int 21h
    ret
ReadChar endp


; Write a character in dl to standard output
WriteChar proc
    mov ah, 02h
    int 21h
    ret
WriteChar endp


; Write carry-return line-feed to standard output
Crlf proc
    mov dl, 0dh
    call WriteChar

    mov dl, 0ah
    call WriteChar

    ret
Crlf endp


; Read an integer from standard input
ReadInt proc
    ; TODO
    ret
ReadInt endp


; Write an integer to standard output
WriteInt proc
    ; TODO
    ret
WriteInt endp


; Read a string from standard input to dx
ReadString proc
    mov ah, 0ah
    int 21h
    ret
ReadString endp


; Write a string from dx to standard output
WriteString proc
    mov ah, 09h
    int 21h
    ret
WriteString endp


; Terminate the program
Terminate proc
    mov ah, 4ch
    int 21h
    ret
Terminate endp


    end start
