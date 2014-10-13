$NOLIST

CSEG

TitleScreen:
	mov state_variable, #0			; Make sure oven is off, when program turned on/reset
	
	;First row
	lcall ClearScreen
	mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'R'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'f'
    lcall LCD_Put
    mov a, #'l'
    lcall LCD_Put
    mov a, #'o'
    lcall LCD_Put
    mov a, #'w'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'O'
    lcall LCD_Put
    mov a, #'v'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'n'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
	
	;Second row
	mov a, #' '
	lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'C'
    lcall LCD_Put
    mov a, #'o'
    lcall LCD_Put
    mov a, #'n'
    lcall LCD_Put
    mov a, #'t'
    lcall LCD_Put
    mov a, #'r'
    lcall LCD_Put
    mov a, #'o'
    lcall LCD_Put
    mov a, #'l'
    lcall LCD_Put
 	mov a, #'l'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
	mov a, #'r'
	lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec
    lcall WaitHalfSec

Select_StartMode:
    ;First row
	lcall ClearScreen
    mov a, #'K'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'y'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
	mov a, #'2'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'~'			;Arrow ->
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'R'
    lcall LCD_Put
    mov a, #'u'
    lcall LCD_Put
    mov a, #'n'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'M'
    lcall LCD_Put
    mov a, #'o'
    lcall LCD_Put
    mov a, #'d'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
	
	;Second row
    mov a, #'K'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'y'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
	mov a, #'3'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'~'			;Arrow ->
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'S'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'t'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'M'
    lcall LCD_Put
    mov a, #'o'
    lcall LCD_Put
    mov a, #'d'
    lcall LCD_Put
    mov a, #'e'
	lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put

    lcall WaitHalfSec
    
    jb KEY.3, GotoNextSelection
    mov StartMode, #1				;Set Mode
    sjmp Leave_Selection
    
GotoNextSelection:    
    jb KEY.2, Select_StartMode_Temp
    clr StartMode					;Run Mode
    sjmp Leave_Selection
Leave_Selection:
    ret
    
Select_StartMode_Temp:
	ljmp Select_StartMode   

$LIST
