data segment
    promptMessage db 'Please enter the sentence:$'
    wordCountMessage db 'Number of words: $'
    studentNumberMessage db 'Student number: $'
    resultMessage db 'Result i = (student num) % (number of words) + 1: $'
    ithWordMessage db 'The i-th word is: $'
    inputBuffer db 255       ; Maximum number of characters (excluding the length byte)
    inputLength db ?         ; Actual number of characters read (not including the carriage return)
    inputString db 255 dup('$') ; Buffer to store the input string
    newline db 0Dh, 0Ah, '$' ; Carriage return and line feed
    studentNumber dw 1234    ; Four-digit student number constant
    wordCount dw ?           ; Variable to store the word count
    resultI dw ?             ; Variable to store the computed value of i
data ends

stack segment para stack
    db 100h dup(0)
stack ends

code segment
    assume cs:code, ds:data, ss:stack

start:
    mov ax, data
    mov ds, ax
    
    ; Display the prompt message
    lea dx, promptMessage
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt
    
    ; Prepare buffer for input
    lea dx, inputBuffer
    mov ah, 0Ah          ; DOS function: Buffered input
    int 21h              ; Call DOS interrupt
    
    ; Print a new line
    lea dx, newline
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt

    ; Count the number of words in the input string
    lea si, inputBuffer+2 ; SI points to the start of the input string (skip length byte and unused byte)
    call CountWords
    
    ; Store the word count in memory
    mov wordCount, cx    ; Store CX into wordCount

    ; Display the word count message
    lea dx, wordCountMessage
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt
    
    ; Convert the word count to ASCII and display
    mov ax, wordCount    ; Move the word count to AX
    mov bx, ax           ; Move the word count to BX
    call PrintNumber     ; Call procedure to print the number

    ; Print a new line
    lea dx, newline
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt

    ; Display the student number message
    lea dx, studentNumberMessage
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt

    ; Display the student number
    mov ax, studentNumber ; Load student number into AX
    mov bx, ax           ; Move student number to BX
    call PrintNumber     ; Call procedure to print the student number

    ; Compute i = (student num) % (number of words) + 1
    mov ax, studentNumber ; Load student number into AX
    xor dx, dx           ; Clear DX for division
    mov cx, wordCount    ; Move the word count from memory to CX
    div cx               ; AX = AX / CX, DX = AX % CX (DX contains the remainder)
    inc dx               ; i = (student num % number of words) + 1

    ; Store the result i in memory
    mov resultI, dx      ; Store DX into resultI

    ; Print a new line
    lea dx, newline
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt

    ; Display the result message
    lea dx, resultMessage
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt

    ; Display the result i
    mov ax, resultI      ; Load resultI into AX
    mov bx, ax           ; Move result i to BX
    call PrintNumber     ; Call procedure to print the number

    ; Print a new line
    lea dx, newline
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt

    ; Display the i-th word message
    lea dx, ithWordMessage
    mov ah, 09h          ; DOS function: Write string to standard output
    int 21h              ; Call DOS interrupt

    ; Print the i-th word
    mov cx, resultI      ; Load the value of i into CX
    lea si, inputBuffer+2 ; SI points to the start of the input string (skip length byte and unused byte)
    call PrintIthWord    ; Call procedure to print the i-th word

    ; Terminate the program
    mov ah, 4Ch          ; DOS function: Terminate process
    int 21h              ; Call DOS interrupt

; Procedure to count the number of words in a string
CountWords proc
    mov cx, 0            ; Clear word count
    mov di, 0            ; DI will hold a flag for in-word status
    mov bx, 0            ; BX will be used as index

countWordsLoop:
    mov al, [si + bx]    ; Load the next byte from the input string into AL
    cmp al, 0Dh          ; Check if it's a carriage return (end of input)
    je countWordsEnd     ; If it is, jump to end

    ; Check if the current character is a space
    cmp al, ' '
    je foundSpace
    
    ; If not a space and not currently in a word, it's the start of a new word
    cmp di, 1
    je continueCount     ; If already in a word, continue to the next character
    mov di, 1            ; Set in-word flag
    inc cx               ; Increment word count
    jmp continueCount    ; Continue counting words

foundSpace:
    mov di, 0            ; Reset in-word flag

continueCount:
    inc bx               ; Move to the next character
    jmp countWordsLoop   ; Continue counting words

countWordsEnd:
    ret
CountWords endp

; Procedure to print a number in BX
PrintNumber proc
    mov ax, bx           ; Move the number to AX
    xor cx, cx           ; Clear CX (it will be used to store digit count)
    mov bx, 10           ; Base 10

    ; Push digits onto the stack to print in correct order
convertLoop:
    xor dx, dx           ; Clear DX
    div bx               ; Divide AX by 10
    add dl, '0'          ; Convert remainder to ASCII
    push dx              ; Push digit onto the stack
    inc cx               ; Increment digit count
    test ax, ax          ; Check if AX is zero
    jnz convertLoop      ; If not, continue loop

    ; Print digits from the stack
printLoop:
    pop dx               ; Pop digit from stack
    mov ah, 02h          ; DOS function: Write character to standard output
    int 21h              ; Call DOS interrupt
    loop printLoop       ; Loop until all digits are printed

    ret
PrintNumber endp

; Procedure to print the i-th word from the input string
PrintIthWord proc
    mov bx, 0            ; BX will be used as index
    mov di, 0            ; DI will hold a flag for in-word status
    mov dx, 0            ; DX will hold the current word number

findWordLoop:
    mov al, [si + bx]    ; Load the next byte from the input string into AL
    cmp al, 0Dh          ; Check if it's a carriage return (end of input)
    je printWordEnd      ; If it is, jump to end

    ; Check if the current character is a space
    cmp al, ' '
    je foundSpacePrint

    ; If not a space and not currently in a word, it's the start of a new word
    cmp di, 1
    je continueFind      ; If already in a word, continue to the next character
    mov di, 1            ; Set in-word flag
    inc dx               ; Increment current word number
    cmp dx, cx           ; Check if the current word number is the i-th word
    jne continueFind     ; If not, continue to the next character
    call PrintCurrentWord ; If it is, print the current word
    jmp printWordEnd     ; End the procedure

foundSpacePrint:
    mov di, 0            ; Reset in-word flag

continueFind:
    inc bx               ; Move to the next character
    jmp findWordLoop     ; Continue finding the word

printWordEnd:
    ret
PrintIthWord endp

; Procedure to print the current word starting at [si + bx]
PrintCurrentWord proc
    ; Print characters until the next space or end of input
printWordCharLoop:
    mov al, [si + bx]    ; Load the next byte from the input string into AL
    cmp al, ' '          ; Check if it's a space
    je printCurrentWordEnd ; If it is, end the word printing
    cmp al, 0Dh          ; Check if it's a carriage return (end of input)
    je printCurrentWordEnd ; If it is, end the word printing
    mov dl, al           ; Move character to DL for printing
    mov ah, 02h          ; DOS function: Write character to standard output
    int 21h              ; Call DOS interrupt
    inc bx               ; Move to the next character
    jmp printWordCharLoop ; Continue printing the word

printCurrentWordEnd:
    ret
PrintCurrentWord endp

code ends
    end start