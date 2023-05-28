

; Author: Mirza Areeb Baig

; Binary to Decimal Converter

INCLUDE Irvine32.inc

.DATA
    input_msg   BYTE    "[+] Enter the Binary String: ", 0
    binaryStr BYTE    32 DUP(?)                                             ; Input binary number
    decimal     DWORD   ?                                                     ; Decimal equivalent
    empty_input BYTE    "[-] Error: Input cannot be Empty", 0ah, 0
    errorMsg    BYTE    "[-] Error: Invalid Binary Number Entered", 0ah, 0
    success_msg BYTE    "[+] The Decimal value of this Binary is: ", 0
       
.CODE
main PROC
    call    PromptInput
    call    ValidateInput
    call    ConvertToDecimal
    call    DisplayResult
    call    ExitProgram
main ENDP

; Prompt for input
PromptInput PROC
    
    promptLoop:
    mov     edx, OFFSET input_msg
    call WriteString

    mov     edx, OFFSET binaryStr
    mov     ecx, SIZEOF binaryStr
    call    ReadString

    cmp     byte ptr [edx], 0     ; Check if input is empty
    je      EmptyAlert            ; If input is empty, prompt again

    ret

    EmptyAlert:
        mov     edx, OFFSET empty_input
        call WriteString
        jmp promptLoop
    ret
PromptInput ENDP



; Validate input
ValidateInput PROC
    mov     esi, 0
    xor     ecx, ecx
    xor     ebx, ebx   ; Fractional part flag

validateInputLoop:
    mov     al, [edx + esi]       ; Get a character from input string
    cmp     al, 0                 ; Check for end of string
    je      validateInputDone     ; If end of string, exit validation
    
    cmp     al, '0'               ; Check if character is '0'
    je      validCharacter
    
    cmp     al, '1'               ; Check if character is '1'
    je      validCharacter
    
    ; Invalid character entered, display error message and exit
    call    DisplayErrorMessage

    call    ExitProgram
    
validCharacter:
    inc     esi
    inc     ecx
    jmp     validateInputLoop

validateInputDone:
    ret
ValidateInput ENDP

; Convert binary to decimal
ConvertToDecimal PROC
    mov     esi, ecx              ; Length of input string
    mov     ebx, 1                ; Multiplier for calculating decimal value
    xor     ecx, ecx              ; Clear ECX for sum calculation
    dec     esi                   ; Decrement index to account for zero-based indexing
    
convertLoop:
    mov     al, [edx + esi]       ; Get a character from input string
    sub     al, '0'               ; Convert character to numeric value
    imul    eax, ebx              ; Multiply numeric value by multiplier
    add     ecx, eax              ; Add result to sum
    imul    ebx, 2                ; Update multiplier by multiplying it by 2
    dec     esi                   ; Decrement index
    xor     eax, eax              ; Resetting EAX  [ FACED ISSUE: WITH EAX REGISTERS DUE TO LONG BINARY INPUT]
    cmp     esi, 0                ; Check if end of string
    jge     convertLoop
    
    mov     decimal, ecx          ; Store decimal result
    ret
ConvertToDecimal ENDP

; Display the result
DisplayResult PROC
    mov     edx, OFFSET success_msg
    call    WriteString

    mov     eax, decimal
    call    WriteDec
    call    Crlf
    ret
DisplayResult ENDP

; Display error message
DisplayErrorMessage PROC
    mov     edx, OFFSET errorMsg   ; Error message
    call    WriteString
    call main
DisplayErrorMessage ENDP

; Exit the program
ExitProgram PROC
    call    WaitMsg
    exit
ExitProgram ENDP

END main
