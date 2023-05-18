; 数据段，存放数据
data segment
    ; 定义欢迎信息字符串，以 $ 结尾
    welcomeMessage db 'Hello BJUT 80986 MASM assembly programming!', '$'
data ends

; 堆栈段，存放堆栈数据
stack segment para stack
    ; 分配 100h 字节的堆栈空间，初始化为 0
    db 100h dup(0)
stack ends

; 代码段，存放程序代码
code segment
    ; 告知编译器 cs 代表代码段，ds 代表数据段，ss 代表堆栈段
    assume cs: code, ds: data, ss: stack

; 程序入口点
start:
    ; 将数据段地址传给 ax
    mov ax, data
    ; 初始化数据段寄存器 ds
    mov ds, ax

    ; 将欢迎信息字符串地址传给 dx
    lea dx, welcomeMessage
    ; 调用 WriteString 过程，将字符串写入标准输出
    call WriteString

    ; 调用 Terminate 过程，终止程序
    call Terminate

; 将 dx 中的字符串写入标准输出
WriteString proc
    ; 设置 ah 为 09h，对应 DOS 功能 09h：写字符串至标准输出
    mov ah, 09h
    ; 调用 DOS 中断 21h，执行相应功能
    int 21h
    ; 返回调用处
    ret
WriteString endp

; 终止程序
Terminate PROC
    ; 设置 ax 为 4C00h，对应 DOS 功能 4Ch：终止程序
    mov ax, 4C00h
    ; 调用 DOS 中断 21h，执行相应功能
    int 21h
    ; 返回调用处
    ret
Terminate ENDP

; 结束代码段
code ends
    ; 设置程序入口点为 start
    end start