; template for masm for DOS (16 bit) programming using simplified segment definition
title YOUR TITLE HERE

.model small

.stack 100h

.data
; TODO: PUT YOUR DATA DEFINITION HERE
msg db "Hello BJUT x86 MASM assembly programming!", "$"

.code
start:
    mov ax, @data
    mov ds, ax

    ;TODO: PUT YOUR CODE HERE
    mov ah, 09h
    mov dx, offset msg
    int 21h

    mov ah, 4ch
    int 21h
end start