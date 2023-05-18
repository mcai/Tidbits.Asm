data segment
    welcomeMessage db 'Hello BJUT 80986 MASM assembly programming!', '$' ; 欢迎信息
data ends

stack segment para stack
    db 100h dup(0)
stack ends

code segment
    assume cs: code, ds: data, ss: stack
start:
    mov ax, data ; 初始化
    mov ds, ax

    lea dx, welcomeMessage ; 提示
    call WriteString

    call Terminate ; 终止程序

; 将 dx 中的字符串写入标准输出
WriteString proc
    mov ah, 09h
    int 21h
    ret
WriteString endp

Terminate PROC
    mov ax, 4C00h         ; DOS 功能 4Ch: 终止程序
    int 21h               ; 调用 DOS 中断
    ret
Terminate ENDP

code ends
    end start