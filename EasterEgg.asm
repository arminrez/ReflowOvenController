$NOLIST

CSEG

EasterEgg:
	mov a, checkingvariable
	
	jnb SWA.1, JumpAwayClearCheck
	cjne a, #1, JumpAway
	
	mov checkingvariable, #2
	sjmp JumpAway
JumpAwayClearCheck:					;If SW1 is turned off, then reset
	mov a, checkingvariable
	cjne a, #2, JumpAway
	mov checkingvariable, #1

JumpAway:
	mov a, checkingvariable
	
	jnb SWA.0, JumpAway2
	cjne a, #2, JumpAway2

	mov checkingvariable, #3
	
JumpAway2:
	mov a, checkingvariable
	
	cjne a, #3, FinishEgg
	jb SWA.0, FinishEgg
	jb SWA.1, FinishEgg

;Save the time
	mov seconds_storage, seconds
	mov minutes_storage, minutes
;Stop (don't show) time
	lcall ClearHex

;Show 'C' after switches off
	lcall display_Cegg

;Delay before showing easter egg
	lcall WaitHalfSec
	lcall WaitHalfSec
	lcall WaitHalfSec
	lcall WaitHalfSec
	lcall WaitHalfSec
	lcall WaitHalfSec
	lcall WaitHalfSec
	lcall WaitHalfSec

KFCgoodness:
	mov LEDRA, #0
	mov LEDRB, #0
	mov LEDRC, #0
	lcall ClearScreen
	
	lcall FirstRow_KFCgoodness
	lcall SecondRow_KFCgoodness
	lcall WaitHalfSec
	
	jnb KEY.2, EndEgg				;Press any button to return
	jnb KEY.3, EndEgg
	
	jb KEY.1, KFCgoodness
	jnb KEY.1, $
EndEgg:
	ljmp Ready_State_Forever_Temp
FinishEgg:
	ret
	
Ready_State_Forever_Temp:
	mov checkingvariable, #1		;Reactivation
	mov seconds, seconds_storage	;Returns time
	mov minutes, minutes_storage
	ljmp Ready_State_Forever

	
FirstRow_KFCgoodness:	
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #'F'
    lcall LCD_put
    mov a, #'i'
    lcall LCD_put
    mov a, #'n'
    lcall LCD_put
    mov a, #'g'
    lcall LCD_put
    mov a, #'e'
    lcall LCD_put
    mov a, #'r'
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    ret

SecondRow_KFCgoodness:
	mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #'L'
    lcall LCD_put
    mov a, #'i'
    lcall LCD_put
	mov a, #'c'
    lcall LCD_put
    mov a, #'k'
    lcall LCD_put
    mov a, #'i'
    lcall LCD_put
    mov a, #'n'
    lcall LCD_put
	mov a, #27H				;Apostrophe
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #'G'
    lcall LCD_put
    mov a, #'o'
    lcall LCD_put
	mov a, #'o'
    lcall LCD_put
    mov a, #'d'
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
	mov a, #' '
    lcall LCD_put
    ret

    
;For smooth transition into easter egg
Display_Cegg:
	;Row1
	lcall ClearScreen
	mov a, #'R'
    lcall LCD_put
    mov a, #'T'
    lcall LCD_put
    mov a, #':'
    lcall LCD_put
    
	lcall Display_Temperature_Room
	
	mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #'O'
    lcall LCD_put
    mov a, #'T'
    lcall LCD_put
    mov a, #':'
    lcall LCD_put
	
	load_y_oven(32)		;Change F to C
	lcall sub32_oven
	
	load_y_oven(5)
	lcall mul32_oven
	
	load_y_oven(9)
	lcall div32_oven
	
	lcall hex2bcd_oven
	
   	mov dptr, #myASCII  
	mov a, bcd_oven+1
	anl a, #0FH
	movc a, @a+dptr
	lcall LCD_put

	mov a, bcd_oven+0
	swap a
	anl a, #0FH
	movc a, @a+dptr
	lcall LCD_put
	
	mov a, bcd_oven+0
	anl a, #0FH
	movc a, @a+dptr
	lcall LCD_put
	
	mov a, #'C'
	lcall LCD_put
   	
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    
    ;Row2
	mov a, #'R'
	lcall LCD_put
    mov a, #'e'
    lcall LCD_put
    mov a, #'a'
    lcall LCD_put
    mov a, #'d'
    lcall LCD_put
    mov a, #'y'
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
 	mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
	mov a, #'R'
	lcall LCD_put
    mov a, #'u'
    lcall LCD_put
    mov a, #'n'
    lcall LCD_put
    ret

$LIST
