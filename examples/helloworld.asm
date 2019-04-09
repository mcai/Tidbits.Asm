data segment
    msg db "Hello world!", "$"
data ends

code segment
    assume cs: code, ds: data

    start:
        mov ax, data
        mov ds, ax

        mov ah, 09h
        lea dx, msg
        int 21h

    stop:
        mov ax, 4c00h
        int 21h
code ends
    end start