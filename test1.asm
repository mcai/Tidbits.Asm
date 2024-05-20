data segment
    ; 定义提示信息
    promptMessage db 'Please enter the sentence:$'
    wordCountMessage db 'Number of words: $'
    studentNumberMessage db 'Student number: $'
    resultMessage db 'Result i = (student num) % (number of words) + 1: $'
    ithWordMessage db 'The i-th word is: $'
    
    ; 定义输入缓冲区
    inputBuffer db 255       ; 最大字符数（不包括长度字节）
    inputLength db ?         ; 实际读取的字符数（不包括回车符）
    inputString db 255 dup('$') ; 存储输入字符串的缓冲区
    
    ; 定义换行符
    newline db 0Dh, 0Ah, '$' ; 回车符和换行符
    
    ; 定义学号常量和变量
    studentNumber dw 1234    ; 四位数学号常量
    wordCount dw ?           ; 存储单词数的变量
    resultI dw ?             ; 存储计算结果 i 的变量
data ends

stack segment para stack
    db 100h dup(0)
stack ends

code segment
    assume cs:code, ds:data, ss:stack

start:
    mov ax, data
    mov ds, ax
    
    ; 显示提示信息
    lea dx, promptMessage
    call PrintString
    
    ; 准备输入缓冲区
    lea dx, inputBuffer
    mov ah, 0Ah          ; DOS 功能：缓冲区输入
    int 21h              ; 调用 DOS 中断
    
    ; 打印换行符
    call PrintNewline

    ; 统计输入字符串中的单词数
    lea si, inputBuffer+2 ; SI 指向输入字符串的开头（跳过长度字节和未使用字节）
    call CountWords
    
    ; 将单词数存储到内存中
    mov wordCount, cx    ; 将 CX 存储到 wordCount

    ; 显示单词数信息
    lea dx, wordCountMessage
    call PrintString
    
    ; 将单词数转换为 ASCII 并显示
    mov ax, wordCount    ; 将单词数移动到 AX
    call PrintNumber

    ; 打印换行符
    call PrintNewline

    ; 显示学号信息
    lea dx, studentNumberMessage
    call PrintString

    ; 显示学号
    mov ax, studentNumber ; 将学号加载到 AX
    call PrintNumber

    ; 计算 i = (学号) % (单词数) + 1
    mov ax, studentNumber ; 将学号加载到 AX
    xor dx, dx           ; 清零 DX 用于除法
    mov cx, wordCount    ; 将内存中的单词数移动到 CX
    div cx               ; AX = AX / CX，DX = AX % CX（DX 包含余数）
    inc dx               ; i = (学号 % 单词数) + 1

    ; 将结果 i 存储到内存中
    mov resultI, dx      ; 将 DX 存储到 resultI

    ; 打印换行符
    call PrintNewline

    ; 显示结果信息
    lea dx, resultMessage
    call PrintString

    ; 显示结果 i
    mov ax, resultI      ; 将 resultI 加载到 AX
    call PrintNumber

    ; 打印换行符
    call PrintNewline

    ; 显示第 i 个单词的信息
    lea dx, ithWordMessage
    call PrintString

    ; 打印第 i 个单词
    mov cx, resultI      ; 将 i 的值加载到 CX
    lea si, inputBuffer+2 ; SI 指向输入字符串的开头（跳过长度字节和未使用字节）
    call PrintIthWord

    ; 终止程序
    mov ah, 4Ch          ; DOS 功能：终止进程
    int 21h              ; 调用 DOS 中断

; 打印字符串的过程
PrintString proc
    mov ah, 09h          ; DOS 功能：将字符串写入标准输出
    int 21h              ; 调用 DOS 中断
    ret
PrintString endp

; 打印换行符的过程
PrintNewline proc
    lea dx, newline
    call PrintString
    ret
PrintNewline endp

; 统计字符串中单词数的过程
CountWords proc
    mov cx, 0            ; 清零单词计数
    mov di, 0            ; DI 将保存单词状态的标志
    mov bx, 0            ; BX 将用作索引

countWordsLoop:
    mov al, [si + bx]    ; 将输入字符串的下一个字节加载到 AL
    cmp al, 0Dh          ; 检查是否为回车符（输入结束）
    je countWordsEnd     ; 如果是，跳转到结束

    ; 检查当前字符是否为空格
    cmp al, ' '
    je foundSpace
    
    ; 如果不是空格且当前不在单词中，则是新单词的开始
    cmp di, 1
    je continueCount     ; 如果已经在单词中，继续下一个字符
    mov di, 1            ; 设置单词状态标志
    inc cx               ; 单词计数加 1
    jmp continueCount    ; 继续统计单词

foundSpace:
    mov di, 0            ; 重置单词状态标志

continueCount:
    inc bx               ; 移动到下一个字符
    jmp countWordsLoop   ; 继续统计单词

countWordsEnd:
    ret
CountWords endp

; 打印 AX 中数字的过程
PrintNumber proc
    xor cx, cx           ; 清零 CX（用于存储数字计数）
    mov bx, 10           ; 基数 10

    ; 将数字压入栈中以正确顺序打印
convertLoop:
    xor dx, dx           ; 清零 DX
    div bx               ; 将 AX 除以 10
    add dl, '0'          ; 将余数转换为 ASCII
    push dx              ; 将数字压入栈中
    inc cx               ; 数字计数加 1
    test ax, ax          ; 检查 AX 是否为零
    jnz convertLoop      ; 如果不是，继续循环

    ; 从栈中弹出数字并打印
printLoop:
    pop dx               ; 从栈中弹出数字
    mov ah, 02h          ; DOS 功能：将字符写入标准输出
    int 21h              ; 调用 DOS 中断
    loop printLoop       ; 循环直到所有数字都打印完

    ret
PrintNumber endp

; 从输入字符串中打印第 i 个单词的过程
PrintIthWord proc
    mov bx, 0            ; BX 将用作索引
    mov di, 0            ; DI 将保存单词状态的标志
    mov dx, 0            ; DX 将保存当前单词编号

findWordLoop:
    mov al, [si + bx]    ; 将输入字符串的下一个字节加载到 AL
    cmp al, 0Dh          ; 检查是否为回车符（输入结束）
    je printWordEnd      ; 如果是，跳转到结束

    ; 检查当前字符是否为空格
    cmp al, ' '
    je foundSpacePrint

    ; 如果不是空格且当前不在单词中，则是新单词的开始
    cmp di, 1
    je continueFind      ; 如果已经在单词中，继续下一个字符
    mov di, 1            ; 设置单词状态标志
    inc dx               ; 当前单词编号加 1
    cmp dx, cx           ; 检查当前单词编号是否为第 i 个单词
    jne continueFind     ; 如果不是，继续下一个字符
    call PrintCurrentWord ; 如果是，打印当前单词
    jmp printWordEnd     ; 结束过程

foundSpacePrint:
    mov di, 0            ; 重置单词状态标志

continueFind:
    inc bx               ; 移动到下一个字符
    jmp findWordLoop     ; 继续查找单词

printWordEnd:
    ret
PrintIthWord endp

; 从 [si + bx] 开始打印当前单词的过程
PrintCurrentWord proc
    ; 打印字符直到下一个空格或输入结束
printWordCharLoop:
    mov al, [si + bx]    ; 将输入字符串的下一个字节加载到 AL
    cmp al, ' '          ; 检查是否为空格
    je printCurrentWordEnd ; 如果是，结束单词打印
    cmp al, 0Dh          ; 检查是否为回车符（输入结束）
    je printCurrentWordEnd ; 如果是，结束单词打印
    mov dl, al           ; 将字符移动到 DL 用于打印
    mov ah, 02h          ; DOS 功能：将字符写入标准输出
    int 21h              ; 调用 DOS 中断
    inc bx               ; 移动到下一个字符
    jmp printWordCharLoop ; 继续打印单词

printCurrentWordEnd:
    ret
PrintCurrentWord endp

code ends
    end start