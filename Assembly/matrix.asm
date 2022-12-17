.code
org 100h

call main

ret

;main proc
main PROC

  CALL take_input         ;Perform the required operation according to the user's selection
  CMP operator, '+'
  JE addm
  CMP operator, '-'
  JE subm
  CMP operator, '*'
  JE multm
  
  addm:                   ;ADD the two matrices
  MOV DX, ca              ;The two matrices must have the same number of rows and columns for the addition to be performed
  CMP DX, cb          
  JNE wrong_dim           ;If they don't have the same dimensions exit the program
  MOV DX, ra
  CMP DX, rb
  JNE wrong_dim
  CALL addition
  LEA DX, add_res_msg
  CALL print_string
  MOV BX, ra
  MOV AL, BL
  MOV BX, ca
  MOV AH, BL
  CALL print_matrix
  ret

  subm:                        ;Subtract the two matrices
  MOV DX, ca
  CMP DX, cb
  JNE wrong_dim
  MOV DX, ra
  CMP DX, rb
  JNE wrong_dim
  CALL subtraction
  LEA DX, sub_res_msg
  CALL print_string
  MOV BX, ra
  MOV AL, BL
  MOV BX, ca
  MOV AH, BL
  CALL print_matrix
  ret

  multm:                      ;Multiply the two matrices
  MOV DX, ca
  CMP DX, rb
  JNE wrong_dim
  CALL multiply
  LEA DX, mul_res_msg
  CALL print_string
  MOV BX, ra
  MOV AL, BL
  MOV BX, cb
  MOV AH, BL
  CALL print_matrix
  ret


  wrong_dim:                  ;Show the wrong dimension error message and exit the program
  CALL clear_screan
  LEA DX, invalid_dim_msg
  CALL print_string
  ret 

  overflow:                   ;Show the overflow error message and exit the program
  LEA DX, overflow_msg
  CALL print_string
  CALL clear_screan
  ret
main ENDP

;Multiplies the matrices
multiply PROC
  PUSHA
  MOV BX, 0
  MOV CX, ra
  X1:
    MOV SI, 0
    PUSH CX
    MOV CX, cb
    X2:
      MOV DI, 0
      MOV BP, 0
      PUSH CX
      MOV CX, ca
      X3:
        MOV AX, matrixA[BX +  DI]
        MUL WORD PTR matrixB[BP +  SI]
        CMP DX, 80h
        JE okay
        CMP DX, 0
        JE okay
        JMP overflow
        okay:
        
        ADD WORD PTR matrixC[BX +  SI], AX
        
        
        ADD DI, 2
        ADD BP, 20
      LOOP X3
      POP CX
      ADD SI, 2
    LOOP X2
    POP CX
    ADD BX, 20
  LOOP X1
  POPA
  ret
multiply ENDP

;Adds the matrices
addition PROC
  MOV BX, 0               ;BX controls the row number
  MOV CX, ra
  L1:
  MOV SI, 0               ;SI controls the column number
  PUSH CX
  MOV CX, ca
  L2:
  MOV DX, matrixA[BX +  SI]
  MOV WORD PTR matrixC[BX +  SI], DX
  MOV DX, matrixB[BX +  SI]
  ADD WORD PTR matrixC[BX +  SI], DX
  JO overflow
  ADD SI, 2
  LOOP L2
  POP CX
  ADD BX, 20
  LOOP L1
  ret
addition ENDP

;subtracts the matrices
subtraction PROC
  MOV BX, 0
  MOV CX, ra
  L3:
  MOV SI, 0
  PUSH CX
  MOV CX, ca
  L4:
  MOV DX, matrixA[BX +  SI]
  MOV WORD PTR matrixC[BX +  SI], DX
  MOV DX, matrixB[BX +  SI]
  SUB WORD PTR matrixC[BX +  SI], DX
  JO overflow
  ADD SI, 2
  LOOP L4
  POP CX
  ADD BX, 20
  LOOP L3
  ret
subtraction ENDP

;Advances the cursor during the input to not overwrite the printed numbers on the screen
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
  ADD DL, AL      ;Increment the cursor position by a multiple six characters.(move it to the right)
  POP AX
  MOV BX, 0
  MOV AH, 2
  INT 10h

  INC cursor_pos_counter
  POPA
  ret
advance_cursor_pos ENDP

;Prints the result matrix (matrixC) after the required operation is done
print_matrix PROC
  MOV BX, 0
  MOV CX, 0
  MOV CL, AL      ;No. of rows is passed in AL
  O1:
  MOV SI, 0
  PUSH CX
  MOV CX, 0
  MOV CL, AH      ;No. of columns is passed in AH
  O2:
  PUSH AX
  MOV AX, matrixC[BX +  SI]
  CALL print_number
  MOV DL, 9       ;Print Tab
  MOV AH, 2
  INT 21h
  ADD SI, 2
  POP AX
  LOOP O2
  CALL newline      ;Print newline and carraige return characters
  POP CX
  ADD BX, 20
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

;Clears the screen using video mode interrupt
clear_screan PROC
  PUSH AX
  MOV AX, 3   ;Sets the video mode to 3, clearing the screan
  INT 10h
  POP AX
  ret
clear_screan ENDP

;handles the user input: Takes the two input matrices and the operator
take_input PROC
  ;Make the cursor blink
  MOV CH, 6
  MOV CL, 7
  MOV AH, 1
  INT 10h
  ;Input matrixA
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

  MOV BX, 0
  MOV CX, ra
  I1:
  MOV SI, 0
  PUSH CX
  MOV CX, ca
  I2:
  PUSH BX
  PUSH CX
  CALL input_number
  MOV DX, BX
  POP CX
  POP BX
  MOV WORD PTR matrixA[BX +  SI], DX
  CALL advance_cursor_pos
  ADD SI, 2
  LOOP I2
  CALL newline
  POP CX
  ADD BX, 20
  LOOP I1

  CALL clear_screan
  ;Input matrixB
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

  MOV BX, 0
  MOV CX, rb
  I3:
  MOV SI, 0
  PUSH CX
  MOV CX, cb
  I4:
  PUSH BX
  PUSH CX
  CALL input_number
  MOV DX, BX
  POP CX
  POP BX
  MOV WORD PTR matrixB[BX +  SI], DX
  CALL advance_cursor_pos
  ADD SI, 2
  LOOP I4
  CALL newline
  POP CX
  ADD BX, 20
  LOOP I3

  CALL clear_screan
  ;Input the operator
  LEA DX, op_msg
  CALL print_string
  reenter_op:
  MOV AH, 1
  INT 21h

  CMP AL, '*'
  JE okay_op
  CMP AL, '+'
  JE okay_op
  CMP AL, '-'
  JE okay_op

  MOV DX, OFFSET invalid_op         ;When the operator is invalid, ask the user to reenter it.
  CALL print_string
  JMP reenter_op

  okay_op:
  MOV operator, AL
  CALL clear_screan
  ret

  ;Column number error handling
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

  reset_sign:             ;Resets the sign flag after the input is taken
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
  PUSH AX
  MOV AH, 9
  INT 21h
  POP AX
  ret
print_string ENDP

;Prints numbers, takes input from AX
print_number PROC
  PUSH CX
  MOV CX, 0
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
  DIV ten
  ADD DX, 48
  PUSH DX
  INC CX
  CMP AX, 0
  JNZ print_positive
  PN:
  POP DX
  PUSH AX
  MOV AH, 2
  INT 21h
  POP AX
  LOOP PN
  POP CX
  ret
print_number ENDP

.data
matrixA DW 100 DUP(?)         ;The input matrices

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

matrixC DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?           ;The output matrix
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        DW ?, ?, ?, ?, ?, ?, ?, ?, ?, ?

;Dimensions of the input matrices
ra DW ?     ;No. of rows of matrixA
ca DW ?     ;No. of columns of matrixA
rb DW ?     ;No. of rows of matrixB
cb DW ?     ;No. of columns of matrixB

operator DB ?    ;The required operation (+ - *)

ten DW 10        ;To use with MUL and DIV instructions since they only accept memory or registers

negative_flag DB 0            ;Flag to check if the input number is negative
input_taken_flag db 0
cursor_pos_counter db 1

newline_msg db 10, 13, '$'
invalid_dim_msg db "Invalid matrices dimensions for the required operation!", 10, 13,"Exitting...", '$'
mat_a_dim_msg         db "Enter the dimensions of matrix A:", 10, 13, '$'
mat_b_dim_msg         db "Enter the dimensions of matrix B:", 10, 13, '$'
enter_rows_num_msg    db "Number of rows (Must be between 1 and 10):    ", 10, 13, '$'
enter_columns_num_msg db 10, 13,"Number of columns (Must be between 1 and 10):    ", 10, 13, '$'
error_rows_num_msg db 10, 13,"Error: the number of rows must be between 1 and 10!", 10, 13, '$'
error_columns_num_msg db 10, 13,"Error: the number of columns must be between 1 and 10!", 10, 13, '$'

enter_val_a_msg db 10, 13,"Enter the values in matrix A:", 10, 13, '$'
overflow_msg db 10, 13,"Error: An overflow has occurred!", 10, 13, '$'
enter_val_b_msg db 10, 13,"Enter the values in matrix B:", 10, 13, '$'

op_msg      db "Select the required operation (A ? B) (+ - *):", 10, 13, '$'
add_res_msg db "The result matrix of adding the matrices A and B is:", 10, 13, '$'
sub_res_msg db "The result matrix of subtracting the matrix B from A is:", 10, 13, '$'
mul_res_msg db "The result matrix of multiplying the matrices A and B is:", 10, 13, '$'
invalid_op  db 10, 13,"Invalid operation! Reenter a valid operator.", 10, 13, '$'