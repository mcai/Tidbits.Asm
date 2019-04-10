data segment
    msg db "Hello BJUT x86 MASM assembly programming!", "$"
data ends

code segment
    assume cs: code, ds: data

    start:
        mov ax, data
        mov ds, ax

        mov dx, offset msg
        mov ah, 09h
        int 21h

    stop:
        mov ah, 4ch
        int 21h
code ends
    end start