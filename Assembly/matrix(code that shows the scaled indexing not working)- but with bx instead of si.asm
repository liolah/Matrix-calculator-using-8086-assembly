.code
org 100h

call main

ret

;main proc
main PROC

  CALL take_input
  CALL addition
  CALL newline
  MOV BX, ra
  MOV AL, BL
  MOV BX, ca
  MOV AH, BL
  CALL print_matrix

  ret
  overflow:
  LEA DX, overflow_msg
  CALL print_string
  ret
main ENDP

;Multiplies the matrices
multiply PROC
  
multiply ENDP

;Adds the matrices
addition PROC
  MOV CX, ra
  L1:
  MOV BX, CX
  DEC BX
  PUSH CX
  MOV CX, ca
  L2:
  MOV SI, CX
  DEC SI
  MOV DX, matrixA[BX * 10 + SI]
  MOV WORD PTR matrixC[BX * 10 + SI], DX
  MOV DX, matrixB[BX * 10 + SI]
  ADD WORD PTR matrixC[BX * 10 + SI], DX
  JO overflow
  LOOP L2
  POP CX
  LOOP L1
  ret
addition ENDP

;subtracts the matrices
subtraction PROC
  MOV CX, ra
  L3:
  MOV BX, CX
  DEC BX
  PUSH CX
  MOV CX, ca
  L4:
  MOV SI, CX
  DEC SI
  MOV DX, matrixA[BX * 10 + SI]
  MOV matrixC[BX * 10 + SI], DX
  MOV DX, matrixB[BX * 10 + SI]
  SUB matrixC[BX * 10 + SI], DX
  JO overflow
  LOOP L4
  POP CX
  LOOP L3
  ret
subtraction ENDP

;description
advance_cursor_pos PROC
  PUSHA
  MOV AH, 3       ;Get cursor position
  MOV BX, 0
  INT 10h

  PUSH AX
  MOV CX, DX
  MOV AX, 6
  MUL cursor_pos_counter
  MOV DX, CX
  ADD DL, AL      ;Increment the cursor position by six characters.(move it to the right)
  POP AX
  MOV BX, 0
  MOV AH, 2
  INT 10h

  INC cursor_pos_counter
  POPA
  ret
  ret
advance_cursor_pos ENDP
;Prints the matrices
print_matrix PROC
  MOV CX, 0
  MOV CL, AL
  O1:
  MOV BX, CX
  DEC BX
  PUSH CX
  MOV CX, 0
  MOV CL, AH
  O2:
  MOV SI, CX
  DEC SI
  PUSHA
  MOV AX, matrixC[BX * 10 + SI]
  CALL print_number
  MOV DL, 9
  MOV AH, 2
  INT 21h
  POPA
  LOOP O2
  CALL newline
  POP CX
  LOOP O1
  ret
print_matrix ENDP

;Deletes one input character when backspace key is pressed
delete_char PROC
  PUSHA
  MOV AH, 2    ;Decrement the cursor position by one.(move it backwards one position)
  MOV DL, 8
  INT 21h

  MOV AH, 2    ;Print whiteSpace to remove the printed character
  MOV DL, ' '
  INT 21h

  MOV AH, 2    ;Decrement the cursor position by one.(move it backwards one position)
  MOV DL, 8
  INT 21h
  POPA
  ret
delete_char ENDP

;handles the user input
take_input PROC
  ;Make the cursor blink
  MOV CH, 6
  MOV CL, 7
  MOV AH, 1
  INT 10h

  LEA DX, mat_a_dim_msg
  CALL print_string

  MOV DX, OFFSET enter_rows_num_msg
  CALL print_string
  reenter_rows_num:
  CALL input_number
  CMP BX, 1
  JL dim_error_row
  CMP BX, 10
  JG dim_error_row
  MOV ra, BX

  LEA DX, enter_columns_num_msg
  CALL print_string
  reenter_columns_num:
  CALL input_number
  CMP BX, 1
  JL dim_error_column
  CMP BX, 10
  JG dim_error_column
  MOV ca, BX

  LEA DX, enter_val_a_msg
  CALL print_string

  MOV CX, ra
  I1:
  MOV BX, CX
  DEC BX
  PUSH CX
  MOV CX, ca
  I2:
  MOV SI, CX
  DEC SI
  PUSH BX
  PUSH CX
  CALL input_number
  MOV DX, BX
  POP CX
  POP BX
  MOV matrixA[BX * 10 + SI], DX
  CALL advance_cursor_pos
  LOOP I2
  CALL newline
  POP CX
  LOOP I1

  LEA DX, mat_b_dim_msg
  CALL print_string

  MOV DX, OFFSET enter_rows_num_msg
  CALL print_string
  reenter_rows_num_b:
  CALL input_number
  CMP BX, 1
  JL dim_error_row
  CMP BX, 10
  JG dim_error_row
  MOV rb, BX

  LEA DX, enter_columns_num_msg
  CALL print_string
  reenter_columns_num_b:
  CALL input_number
  CMP BX, 1
  JL dim_error_column
  CMP BX, 10
  JG dim_error_column
  MOV cb, BX

  LEA DX, enter_val_b_msg
  CALL print_string

  MOV CX, rb
  I3:
  MOV BX, CX
  DEC BX
  PUSH CX
  MOV CX, cb
  I4:
  MOV SI, CX
  DEC SI
  PUSH BX
  PUSH CX
  CALL input_number
  MOV DX, BX
  POP CX
  POP BX
  MOV matrixA[BX * 10 + SI], DX
  CALL advance_cursor_pos
  LOOP I4
  CALL newline
  POP CX
  LOOP I3

  ret

  dim_error_row:
  MOV DX, OFFSET error_rows_num_msg
  CALL print_string
  JMP reenter_rows_num

  dim_error_column:
  MOV DX, OFFSET error_columns_num_msg
  CALL print_string
  JMP reenter_columns_num

  dim_error_row_b:
  MOV DX, OFFSET error_rows_num_msg
  CALL print_string
  JMP reenter_rows_num_b

  dim_error_column_b:
  MOV DX, OFFSET error_columns_num_msg
  CALL print_string
  JMP reenter_columns_num_b
take_input ENDP

;Prints newline and carraige return
newline PROC
  PUSHA
  LEA DX, newline_msg
  CALL print_string
  MOV cursor_pos_counter, 1
  POPA
  ret
newline ENDP

;Takes a number input
input_number PROC
  MOV BX, 0     ;Contains the previous number
  MOV negative_flag, 0     ;Contains the previous number
  input_begin:
  MOV AH, 1
  INT 21h
  CMP AL, '-'
  JE set_nagtive
  CMP AL, 8
  JE backspace_entered
  CMP AL, 13
  JE end_input
  CMP AL, '0'
  JB wrong_input
  CMP AL, '9'
  JA wrong_input

  MOV input_taken_flag, 1

  MOV CX, 0     ;Temporary Storage 
  SUB AL, 48    ;Convert from ASCII to digit
  MOV CL, AL
  MOV AX, BX
  MUL ten
  CMP DX, 0         ;Checking for multiplication overflow
  JA wrong_input    
  ADD AX, CX
  CMP AX, 32767     ;Making sure there is a bit left for negation
  JA wrong_input
  MOV BX, AX
  JMP input_begin

  set_nagtive:
  CMP negative_flag, 1
  JE wrong_input
  MOV negative_flag, 1
  JMP input_begin

  backspace_entered:
  CMP BX, 0
  JE reset_sign
  MOV DX, 0
  MOV AX, BX
  DIV ten
  MOV BX, AX
  MOV AH, 2    ;Print whiteSpace to remove the printed character
  MOV DL, ' '
  INT 21h
  MOV AH, 2    ;Decrement the cursor position by one.(move it backwards one position)
  MOV DL, 8
  INT 21h
  JMP input_begin

  CALL delete_char
  JMP input_begin

  wrong_input:
  CALL delete_char
  JMP input_begin

  end_input:
  CMP input_taken_flag, 0
  JE input_begin
  MOV input_taken_flag, 0
  CMP negative_flag, 1
  JE negate:
  ret

  negate:
  NEG BX
  ret

  reset_sign:
  MOV negative_flag, 0
  MOV AH, 2    ;Print whiteSpace to remove the printed character
  MOV DL, ' '
  INT 21h
  MOV AH, 2    ;Decrement the cursor position by one.(move it backwards one position)
  MOV DL, 8
  INT 21h
  JMP input_begin
  
input_number ENDP

;Prints the string located at the address stored in DX
print_string PROC
  MOV AH, 9
  INT 21h
  ret
print_string ENDP

;Prints numbers, takes input from AX
print_number PROC
  CMP AX, 0
  JGE print_positive

  ;The following lines above print_positive gets excuted if the number is negative only
  PUSH AX
  MOV AH, 2
  MOV DL, '-'
  INT 21h
  POP AX
  NEG AX

  print_positive:
  MOV DX, 0
  IDIV ten
  ADD DX, 48
  PUSH AX
  MOV AH, 2
  INT 21h
  POP AX
  CMP AX, 0
  JNZ print_positive

  ret
print_number ENDP

.data
matrixA DW 100 DUP(?)

matrixB DW 10 DUP(?)
        DW 10 DUP(?)
        DW 10 DUP(?)
        DW 10 DUP(?)
        DW 10 DUP(?)
        DW 10 DUP(?)
        DW 10 DUP(?)
        DW 10 DUP(?)
        DW 10 DUP(?)
        DW 10 DUP(?)

matrixC DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?

ra DW ?     ;No. of rows of matrixA
ca DW ?     ;No. of columns of matrixA
rb DW ?     ;No. of rows of matrixB
cb DW ?     ;No. of columns of matrixB

operator DB ?    ;The required operation (+ - *)

ten DW 10        ;To use with MUL and DIV instructions since they only accept memory or registers

negative_flag DB 0    ;Flag to check if the input number is negative
input_taken_flag db 0
newline_msg db 10, 13, '$'

cursor_pos_counter db 1

invalid_mul db 10, 13,"Invalid matrices dimensions for multiplication!", 10, 13, '$'
invalid_add db 10, 13,"Invalid matrices dimensions for addition!", 10, 13, '$'
invalid_sub db 10, 13,"Invalid matrices dimensions for subtraction!", 10, 13, '$'

mat_a_dim_msg         db "Enter the dimensions of matrix A:", 10, 13, '$'
mat_b_dim_msg         db 10, 13,"Enter the dimensions of matrix B:", 10, 13, '$'
enter_rows_num_msg    db "Number of rows (Must be between 1 and 10):    ", 10, 13, '$'
enter_columns_num_msg db 10, 13,"Number of columns (Must be between 1 and 10):    ", 10, 13, '$'
error_rows_num_msg db 10, 13,"Error: the number of rows must be between 1 and 10!", 10, 13, '$'
error_columns_num_msg db 10, 13,"Error: the number of columns must be between 1 and 10!", 10, 13, '$'

enter_val_a_msg db 10, 13,"Enter the values in matrix A:", 10, 13, '$'
overflow_msg db 10, 13,"Error: An overflow has occurred!", 10, 13, '$'
enter_val_b_msg db 10, 13,"Enter the values in matrix B:", 10, 13, '$'

op_msg      db 10, 13,"Select the required operation (A ? B) (+ - *):", 10, 13, '$'
add_res_msg db 10, 13,"The result matrix of adding the matrices A and B is:", 10, 13, '$'
sub_res_msg db 10, 13,"The result matrix of subtracting the matrices A and B is:", 10, 13, '$'
mul_res_msg db 10, 13,"The result matrix of multiplying the matrices A and B is:", 10, 13, '$'
invalid_op  db 10, 13,"Invalid operation!", 10, 13, '$'

;------------------------------------------------------------------------------------------------------------------------
; INT 10h / AH = 2 - set cursor position.
; input:
; DH = row.
; DL = column.
; BH = page number (0..7).
; example:

; 	mov dh, 10
; 	mov dl, 20
; 	mov bh, 0
; 	mov ah, 2
; 	int 10h
;------------------------------------------------------------------------------------------------------------------------
; INT 10h / AH = 03h - get cursor position and size.
; input:
; BH = page number.
; return:
; DH = row.
; DL = column.
; CH = cursor start line.
; CL = cursor bottom line.
;------------------------------------------------------------------------------------------------------------------------
; INT 21h / AH=1 - read character from standard input, with echo, result is stored in AL.
; if there is no character in the keyboard buffer, the function waits until any key is pressed.

; example:

; 	mov ah, 1
; 	int 21h
; Back to Top 
;------------------------------------------------------------------------------------------------------------------------
; INT 21h / AH=2 - write character to standard output.
; entry: DL = character to write, after execution AL = DL.

; example:

; 	mov ah, 2
; 	mov dl, 'a'
; 	int 21h
;------------------------------------------------------------------------------------------------------------------------
; INT 21h / AH=9 - output of a string at DS:DX. String must be terminated by '$'.

; example:

; 		org 100h
; 		mov dx, offset msg
; 		mov ah, 9
; 		int 21h
; 		ret
; 		msg db "hello world $"
;------------------------------------------------------------------------------------------------------------------------
; INT 10h / AH = 06h - scroll up window.
; INT 10h / AH = 07h - scroll down window.
; input:
; AL = number of lines by which to scroll (00h = clear entire window).
; BH = attribute used to write blank lines at bottom of window.
; CH, CL = row, column of window's upper left corner.
; DH, DL = row, column of window's lower right corner.
;------------------------------------------------------------------------------------------------------------------------
; INT 16h / AH = 00h - get keystroke from keyboard (no echo). Used to wait for user to press any key
; return:
; AH = BIOS scan code.
; AL = ASCII character.
; (if a keystroke is present, it is removed from the keyboard buffer).
;------------------------------------------------------------------------------------------------------------------------
; INT 10h / AH = 01h - set text-mode cursor shape.
; input:
; CH = cursor start line (bits 0-4) and options (bits 5-7).
; CL = bottom cursor line (bits 0-4).

; when bit 5 of CH is set to 0, the cursor is visible. when bit 5 is 1, the cursor is not visible.

; ; hide blinking text cursor: 
;      	mov ch, 32
;      	mov ah, 1
;      	int 10h

; ; show standard blinking text cursor: 
;      	mov ch, 6
;      	mov cl, 7
;      	mov ah, 1
;      	int 10h

; ; show box-shaped blinking text cursor: 
;      	mov ch, 0
;      	mov cl, 7
;      	mov ah, 1
;      	int 10h

; ;     	note: some bioses required CL to be >=7,
; ;     	otherwise wrong cursor shapes are displayed. 