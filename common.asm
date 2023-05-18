; common.asm
; 包含常用的汇编子程序

; 从标准输入读取字符串并存放到 dx 指向的缓冲区
ReadString proc
    ; pusha               ; 保存所有通用寄存器
    ; mov ah, 0Ah         ; 设置 ah 为 0Ah，对应 DOS 功能 0Ah：缓冲区输入
    ; int 21h             ; 调用 DOS 中断 21h，执行相应功能
    ; popa                ; 恢复所有通用寄存器
    ret                 ; 返回调用处
ReadString endp

; 将 dx 中的字符串写入标准输出
WriteString proc
    ; 设置 ah 为 09h，对应 DOS 功能 09h：写字符串至标准输出
    mov ah, 09h
    ; 调用 DOS 中断 21h，执行相应功能
    int 21h
    ; 返回调用处
    ret
WriteString endp

; 从标准输入读取整数并存放到 ax
ReadInt proc
    ; 省略实现...
    ret
ReadInt endp

; 将 ax 中的整数写入标准输出
WriteInt proc
    ; 省略实现...
    ret
WriteInt endp

; 将 al 中的字符写入标准输出
WriteChar proc
    ; pusha                ; 保存所有通用寄存器
    ; mov ah, 02h          ; 设置 ah 为 02h，对应 DOS 功能 02h：写字符至标准输出
    ; int 21h              ; 调用 DOS 中断 21h，执行相应功能
    ; popa                 ; 恢复所有通用寄存器
    ret                  ; 返回调用处
WriteChar endp

; 在标准输出上输出一个换行符
Crlf proc
    ; pusha                ; 保存所有通用寄存器
    ; mov ah, 02h          ; 设置 ah 为 02h，对应 DOS 功能 02h：写字符至标准输出
    ; mov dl, 0Dh          ; 设置 dl 为回车 (CR) 的 ASCII 码
    ; int 21h              ; 调用 DOS 中断 21h，执行相应功能
    ; mov dl, 0Ah          ; 设置 dl 为换行 (LF) 的 ASCII 码
    ; int 21h              ; 调用 DOS 中断 21h，执行相应功能
    ; popa                 ; 恢复所有通用寄存器
    ret                  ; 返回调用处
Crlf endp

; 终止程序
Terminate PROC
    ; 设置 ax 为 4C00h，对应 DOS 功能 4Ch：终止程序
    mov ax, 4C00h
    ; 调用 DOS 中断 21h，执行相应功能
    int 21h
    ; 返回调用处
    ret
Terminate ENDP