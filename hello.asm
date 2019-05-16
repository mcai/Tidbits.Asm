; template for masm for DOS (16 bit) programming using simplified segment definition
title Hello

.model small
.stack 100h

.data
    msg db 'Hello BJUT x86 MASM assembly programming!', '$'
    inputBuffer db 80, ?, 80 dup(?), '$'

.code
start:
    mov ax, @data
    mov ds, ax

    lea dx, msg
    call WriteString

    call Crlf

    lea dx, inputBuffer
    call ReadString

    call Crlf

    ; add $
    xor ch, ch
    mov cl, inputBuffer + 1
    mov bx, cx
    lea si, inputBuffer + 2
    mov byte ptr [bx + si], '$'

    lea dx, inputBuffer + 2
    call WriteString

    call Terminate

ReadChar proc
    ; TODO
    ret
ReadChar endp

WriteChar proc
    mov ah, 02h
    int 21h
    ret
WriteChar endp

Crlf proc
    mov dl, 13
    call WriteChar

    mov dl, 10
    call WriteChar

    ret
Crlf endp

ReadInt proc
    ; TODO
    ret
ReadInt endp

WriteInt proc
    ; TODO
    ret
WriteInt endp

ReadString proc
    mov ah, 0ah
    int 21h
    ret
ReadString endp

WriteString proc
    mov ah, 09h
    int 21h
    ret
WriteString endp

Terminate proc
    mov ah, 4ch
    int 21h
    ret
Terminate endp

end start