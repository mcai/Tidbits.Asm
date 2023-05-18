; common.asm
; 包含常用的汇编子程序

; ----------------------------------------------------------
; 从标准输入读取字符串并存放到 dx 指向的缓冲区
; ----------------------------------------------------------
ReadString proc
    ; 保存寄存器
    push ax              ; 保存 ax 寄存器，因为 int 21h 可能会修改它的值
    push dx              ; 保存 dx 寄存器，因为 int 21h 可能会修改它的值
    
    ; 设置并调用 DOS 功能
    mov ah, 0Ah          ; 设置 ah 为 0Ah，对应 DOS 功能 0Ah：缓冲区输入
    int 21h              ; 调用 DOS 中断 21h，执行相应功能
    
    ; 恢复寄存器
    pop dx               ; 恢复 dx 寄存器，以免影响程序的其他部分
    pop ax               ; 恢复 ax 寄存器，以免影响程序的其他部分
    
    ret                  ; 返回调用处
ReadString endp

; ----------------------------------------------------------
; 将 dx 中的字符串写入标准输出
; ----------------------------------------------------------
WriteString proc
    ; 设置并调用 DOS 功能
    mov ah, 09h           ; 设置 ah 为 09h，对应 DOS 功能 09h：写字符串至标准输出
    int 21h               ; 调用 DOS 中断 21h，执行相应功能
    
    ret                   ; 返回调用处
WriteString endp

; ----------------------------------------------------------
; 从标准输入读取整数并存放到 ax
; ----------------------------------------------------------
ReadInt proc
    ; 保存寄存器
    push ax              ; 保存 ax 寄存器，因为在此过程中可能会修改它的值
    push dx              ; 保存 dx 寄存器，因为在此过程中可能会修改它的值
    push cx              ; 保存 cx 寄存器，因为在此过程中可能会修改它的值
    push bx              ; 保存 bx 寄存器，因为在此过程中可能会修改它的值
    
    ; 初始化寄存器
    xor ax, ax           ; 清零 ax 寄存器，用于存储输入的整数
    xor cx, cx           ; 清零 cx 寄存器，用于存储当前的权重（如 1, 10, 100 等）

    ; 逐个读取字符并转换为整数
ReadIntLoop:
    ; 设置并调用 DOS 功能
    mov ah, 08h          ; 设置 ah 为 08h，对应 DOS 功能 08h：从键盘读取字符（无回显）
    int 21h              ; 调用 DOS 中断 21h，执行相应功能，结果存储在 al 中
    
    ; 检查是否是数字字符
    cmp al, '0'          ; 比较 al 和字符 '0'
    jb ReadIntDone       ; 如果 al < '0'，则跳转到 ReadIntDone
    cmp al, '9'          ; 比较 al 和字符 '9'
    ja ReadIntDone       ; 如果 al > '9'，则跳转到 ReadIntDone

    ; 转换数字字符为数字值并累加到结果
    sub al, '0'          ; 将字符转换为相应的数字值（0 到 9）
    mov bx, cx           ; 将 cx 的值保存到 bx
    imul bx, 10          ; 将 bx 乘以 10
    add ax, bx           ; 将 bx 累加到结果 ax 中
    mov cx, ax           ; 更新 cx 的值以用于下一次循环
    
    ; 继续下一个字符
    jmp ReadIntLoop      ; 继续循环，读取下一个字符

ReadIntDone:
    ; 恢复寄存器
    pop bx               ; 恢复 bx 寄存器，以免影响程序的其他部分
    pop cx               ; 恢复 cx 寄存器，以免影响程序的其他部分
    pop dx               ; 恢复 dx 寄存器，以免影响程序的其他部分
    pop ax               ; 恢复 ax 寄存器，以免影响程序的其他部分
    ret                  ; 返回调用处
ReadInt endp

; ----------------------------------------------------------
; 将 ax 中的整数写入标准输出
; ----------------------------------------------------------
WriteInt proc
    ; 保存寄存器
    push ax              ; 保存 ax 寄存器，因为在此过程中可能会修改它的值
    push dx              ; 保存 dx 寄存器，因为在此过程中可能会修改它的值
    push cx              ; 保存 cx 寄存器，因为在此过程中可能会修改它的值
    push bx              ; 保存 bx 寄存器，因为在此过程中可能会修改它的值
    
    ; 将整数转换为字符串并存储在栈中
    mov cx, 0            ; 初始化计数器 cx 为 0
WriteIntLoop:
    xor dx, dx           ; 清零 dx 寄存器
    mov bx, 10           ; 设置除数 bx 为 10
    div bx               ; 将 ax 除以 10，商存储在 ax 中，余数存储在 dx 中
    add dl, '0'          ; 将余数转换为字符
    push dx              ; 将字符压入栈中
    inc cx               ; 计数器 cx 加 1
    cmp ax, 0            ; 检查 ax 是否为 0
    jne WriteIntLoop     ; 如果 ax 不为 0，则继续循环

    ; 从栈中逐个弹出字符并写入标准输出
WriteIntOutputLoop:
    pop dx               ; 从栈中弹出字符到 dx
    call WriteChar       ; 调用 WriteChar 过程输出字符
    dec cx               ; 计数器 cx 减 1
    cmp cx, 0            ; 检查 cx 是否为 0
    jne WriteIntOutputLoop ; 如果 cx 不为 0，则继续循环

    ; 恢复寄存器
    pop bx               ; 恢复 bx 寄存器，以免影响程序的其他部分
    pop cx               ; 恢复 cx 寄存器，以免影响程序的其他部分
    pop dx               ; 恢复 dx 寄存器，以免影响程序的其他部分
    pop ax               ; 恢复 ax 寄存器，以免影响程序的其他部分
    
    ret                  ; 返回调用处
WriteInt endp

; ----------------------------------------------------------
; 将 al 中的字符写入标准输出
; ----------------------------------------------------------
WriteChar proc
    ; 保存寄存器
    push ax              ; 保存 ax 寄存器，因为 int 21h 可能会修改它的值
    push dx              ; 保存 dx 寄存器，因为 int 21h 可能会修改它的值
    
    ; 设置并调用 DOS 功能
    mov ah, 02h          ; 设置 ah 为 02h，对应 DOS 功能 02h：写字符至标准输出
    int 21h              ; 调用 DOS 中断 21h，执行相应功能
    
    ; 恢复寄存器
    pop dx               ; 恢复 dx 寄存器，以免影响程序的其他部分
    pop ax               ; 恢复 ax 寄存器，以免影响程序的其他部分
    
    ret                  ; 返回调用处
WriteChar endp

; ----------------------------------------------------------
; 在标准输出上输出一个换行符
; ----------------------------------------------------------
Crlf proc
    ; 保存寄存器
    push ax             ; 保存 ax 寄存器
    push bx             ; 保存 bx 寄存器
    push cx             ; 保存 cx 寄存器
    push dx             ; 保存 dx 寄存器
    push si             ; 保存 si 寄存器
    push di             ; 保存 di 寄存器
    push bp             ; 保存 bp 寄存器
    
    ; 设置并调用 DOS 功能
    mov ah, 02h          ; 设置 ah 为 02h，对应 DOS 功能 02h：写字符至标准输出
    mov dl, 0Dh          ; 设置 dl 为回车 (CR) 的 ASCII 码
    int 21h              ; 调用 DOS 中断 21h，执行相应功能
    mov dl, 0Ah          ; 设置 dl 为换行 (LF) 的 ASCII 码
    int 21h              ; 调用 DOS 中断 21h，执行相应功能

    ; 恢复寄存器
    pop bp              ; 恢复 bp 寄存器
    pop di              ; 恢复 di 寄存器
    pop si              ; 恢复 si 寄存器
    pop dx              ; 恢复 dx 寄存器
    pop cx              ; 恢复 cx 寄存器
    pop bx              ; 恢复 bx 寄存器
    pop ax              ; 恢复 ax 寄存器
    
    ret                 ; 返回调用处
Crlf endp

; ----------------------------------------------------------
; 终止程序
; ----------------------------------------------------------
Terminate PROC
    mov ax, 4C00h          ; 设置 ax 为 4C00h，对应 DOS 功能 4Ch：终止程序
    int 21h                ; 调用 DOS 中断 21h，执行相应功能
    ret                    ; 返回调用处
Terminate ENDP