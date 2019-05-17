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

; Print matrix from dx
PrintMatrix proc
    ; TODO
    ret
PrintMatrix endp

; Multiply matrix@ax and matrix@bx, and store result in matrix@cx
MatrixMultiply proc
    ; TODO
    ret
MatrixMultiply endp


; Terminate the program
Terminate proc
    mov ah, 4ch
    int 21h
    ret
Terminate endp
