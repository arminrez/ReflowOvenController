$NOLIST

CSEG

;LCD Initialization
LCD:
    setb LCD_ON								;Initializes LCD Display
    clr LCD_EN								;Default state of enable must be zero
    lcall Wait40us
    mov LCD_MOD, #0xFF						;Use LCD_DATA as output port
    clr LCD_RW								;Only writing to the LCD in this code.
    mov a, #0CH								;Display on command
    lcall LCD_Command
    mov a, #38H								;8-bits interface, 2 lines, 5x7 characters
    lcall LCD_Command		

LCD_Command:
        mov LCD_DATA, A
        clr LCD_RS
        nop
        nop
        setb LCD_EN			;Enable pulse should be at least 230 ns
        nop
        nop
        nop
        nop
        nop
        nop
        clr LCD_EN
        ljmp Wait40us

LCD_Put:
        mov LCD_DATA, A
        setb LCD_RS
        nop
        nop
        setb LCD_EN        ;Enable pulse should be at least 230 ns
        nop
        nop
        nop
        nop
        nop
        nop
        clr LCD_EN
        ljmp Wait40us

ClearScreen:                ;Clears screen
        mov a, #01H 
        lcall LCD_command        
        mov R1, #40
        lcall Clr_loop
        ret

Clr_Loop:
        lcall Wait40us
        djnz R1, Clr_Loop
        ret        

Wait40us:
        mov R0, #149
X1: 
        nop
        nop
        nop
        nop
        nop
        nop
        djnz R0, X1			;9 machine cycles-> 9*30ns*149=40us
        ret

Delay100us:					;100 micro-second delay subroutine 
        mov R1, #10 
        M0: mov R0, #111 
        M1: djnz R0, M1		;111*30ns*3=10us 
        djnz R1, M0			;10*10us=100us, approximately 
        ret
        
        
;LCD Displays for states
DisplayTimeLCD_State0:
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

   	lcall Display_Temperature_Oven
   	
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
    
    mov dptr, #myLut  

	mov A, minutes
	swap a
	anl a, #0FH
	movc A, @A+dptr
	mov HEX7, a

    mov A, minutes
    anl a, #0FH
    movc A, @A+dptr
    mov HEX6, a
    ; Display Decimal
    mov A, seconds
    swap a
    anl a, #0FH
    movc A, @A+dptr
    mov HEX5, a
    ; Display Digit 0
    mov A, seconds
    anl a, #0FH
    movc A, @A+dptr
    mov HEX4, a
    
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    
Display_State0:
	mov a, #'R'
	lcall LCD_Put
    mov a, #'a'
    lcall LCD_Put
    mov a, #'m'
    lcall LCD_Put
    mov a, #'p'
    lcall LCD_Put
    mov a, #'2'
    lcall LCD_Put
    mov a, #'S'
    lcall LCD_Put
    mov a, #'o'
    lcall LCD_Put
    mov a, #'a'
    lcall LCD_Put
    mov a, #'k'
    lcall LCD_Put
    ret
	
DisplayTimeLCD_state1:
	lcall ClearScreen
	mov a, #'R'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put
	lcall Display_Temperature_Room
	mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'O'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put

   	lcall Display_Temperature_Oven
   	
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
    
    mov dptr, #myLut  

	mov A, minutes
	swap a
	anl a, #0fh
	movc A, @A+dptr
	mov HEX7, a

    mov A, minutes
    anl a, #0fh
    movc A, @A+dptr
    mov HEX6, a
    ; Display Decimal
    mov A, seconds
    swap a
    anl a, #0fh
    movc A, @A+dptr
    mov HEX5, a
    ; Display Digit 0
    mov A, seconds
    anl a, #0fh
    movc A, @A+dptr
    mov HEX4, a
    
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
Display_State1:
	mov a, #'P'
	lcall LCD_Put
    mov a, #'r'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'-'
    lcall LCD_Put
    mov a, #'h'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'a'
    lcall LCD_Put
    mov a, #'t'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    ret

	
DisplayTimeLCD_State2:
	lcall ClearScreen
	mov a, #'R'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put
	lcall Display_Temperature_Room
	mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'O'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put

   	lcall Display_Temperature_Oven
   	
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
    
    mov dptr, #myLut  

	mov A, minutes
	swap a
	anl a, #0FH
	movc A, @A+dptr
	mov HEX7, a

    mov A, minutes
    anl a, #0FH
    movc A, @A+dptr
    mov HEX6, a
    ; Display Decimal
    mov A, seconds
    swap a
    anl a, #0FH
    movc A, @A+dptr
    mov HEX5, a
    ; Display Digit 0
    mov A, seconds
    anl a, #0FH
    movc A, @A+dptr
    mov HEX4, a
    
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    
Display_State2:
	mov a, #'R'
	lcall LCD_Put
    mov a, #'a'
    lcall LCD_Put
    mov a, #'m'
    lcall LCD_Put
    mov a, #'p'
    lcall LCD_Put
    mov a, #'2'
    lcall LCD_Put
    mov a, #'P'
    lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'a'
    lcall LCD_Put
    mov a, #'k'
    lcall LCD_Put
    ret
    
    
DisplayTimeLCD_State3:
	lcall ClearScreen
	mov a, #'R'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put
	lcall Display_Temperature_Room
	mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'O'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put

   	lcall Display_Temperature_Oven
   	
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
    
    mov dptr, #myLut  

	mov A, minutes
	swap a
	anl a, #0FH
	movc A, @A+dptr
	mov HEX7, a

    mov A, minutes
    anl a, #0FH
    movc A, @A+dptr
    mov HEX6, a
    ; Display Decimal
    mov A, seconds
    swap a
    anl a, #0FH
    movc A, @A+dptr
    mov HEX5, a
    ; Display Digit 0
    mov A, seconds
    anl a, #0FH
    movc A, @A+dptr
    mov HEX4, a
    
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    
Display_State3:
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
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    ret


DisplayTimeLCD_State4:
	lcall ClearScreen
	mov a, #'R'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put
	lcall Display_Temperature_Room
	mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'O'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put

   	lcall Display_Temperature_Oven
   	
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
    
    mov dptr, #myLut  

	mov A, minutes
	swap a
	anl a, #0FH
	movc A, @A+dptr
	mov HEX7, a

    mov A, minutes
    anl a, #0FH
    movc A, @A+dptr
    mov HEX6, a
    ; Display Decimal
    mov A, seconds
    swap a
    anl a, #0FH
    movc A, @A+dptr
    mov HEX5, a
    ; Display Digit 0
    mov A, seconds
    anl a, #0FH
    movc A, @A+dptr
    mov HEX4, a
    
    mov a, #' '
    lcall LCD_put
    mov a, #' '
    lcall LCD_put
    
Display_State4:
	mov a, #'C'
	lcall LCD_Put
    mov a, #'o'
    lcall LCD_Put
    mov a, #'o'
    lcall LCD_Put
    mov a, #'l'
    lcall LCD_Put
    mov a, #'i'
    lcall LCD_Put
    mov a, #'n'
    lcall LCD_Put
    mov a, #'g'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    ret

DisplayTimeLCD_State_Ready:
	lcall ClearScreen
	mov a, #'R'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put
	lcall Display_Temperature_Room
	mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'O'
    lcall LCD_Put
    mov a, #'T'
    lcall LCD_Put
    mov a, #':'
    lcall LCD_Put

   	lcall Display_Temperature_Oven
   	
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
    
    mov dptr, #myLut  
	
	mov A, minutes
	swap a
	anl a, #0FH
	movc A, @A+dptr
	mov HEX7, a
	
    mov A, minutes
    anl a, #0FH
    movc A, @A+dptr
    mov HEX6, a
    ; Display Decimal
    mov A, seconds
    swap a
    anl a, #0FH
    movc A, @A+dptr
    mov HEX5, a
    ; Display Digit 0
    mov A, seconds
    anl a, #0FH
    movc A, @A+dptr
    mov HEX4, a
    
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    
Display_State_Ready:
	mov a, #'R'
	lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'a'
    lcall LCD_Put
    mov a, #'d'
    lcall LCD_Put
    mov a, #'y'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    ret

Display_Set:
 	mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
	mov a, #'S'
	lcall LCD_Put
    mov a, #'e'
    lcall LCD_Put
    mov a, #'t'
    lcall LCD_Put
    ret

Display_Run:
 	mov a, #' '
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
	mov a, #'R'
	lcall LCD_Put
    mov a, #'u'
    lcall LCD_Put
    mov a, #'n'
    lcall LCD_Put
    ret
     
     
DisplayHEX0to2:
	mov dptr, #myLUT
	
	mov a, seconds_counter+0
	anl a, #0FH
	movc a, @a+dptr
	mov HEX0, a
	
	mov a, seconds_counter+0
	swap a
	anl a, #0FH
	movc a, @a+dptr
	mov HEX1, a
	
	mov a, seconds_counter+1
	anl a, #0FH
	movc a, @a+dptr
	mov HEX2, a
	
	mov HEX3, #0FFH
	
	ret
	
;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;	

ShowPreset:
	lcall DisplayTimerHEX
	
    mov a, #'R'
    lcall LCD_Put
    mov a, #'2'
    lcall LCD_Put
    mov a, #'S'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'P'
    lcall LCD_Put
    mov a, #'H'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'R'
    lcall LCD_Put
    mov a, #'2'
    lcall LCD_Put
    mov a, #'P'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'R'
    lcall LCD_Put
    mov a, #'f'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'C'
    lcall LCD_Put
    mov a, #'l'
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
    ret

Preset1:
	mov a, #'1'
    lcall LCD_Put
    mov a, #'3'
    lcall LCD_Put
    mov a, #'5'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
	mov a, #'6'
    lcall LCD_Put
    mov a, #'5'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'2'
    lcall LCD_Put
	mov a, #'1'
    lcall LCD_Put
    mov a, #'0'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'4'
    lcall LCD_Put
	mov a, #'5'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'4'
    lcall LCD_Put
	mov a, #'5'
    lcall LCD_Put
    
    jnb SWA.5, Continuing_a
    jb SWA.5, $
    
 	mov rampsoak+0, #35H	;135
	mov rampsoak+1, #01H
	mov preheat+0, #65H		;65
	mov preheat+1, #00H
	mov ramppeak+0, #10H	;210
	mov ramppeak+1, #02H
	mov reflow+0, #45H		;45
	mov reflow+1, #00H
	mov cooling+0, #45H		;45
	mov cooling+1, #00H
Continuing_a:
	ret
	
Preset2:
	mov a, #'1'
    lcall LCD_Put
    mov a, #'6'
    lcall LCD_Put
    mov a, #'5'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
	mov a, #'5'
    lcall LCD_Put
    mov a, #'0'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'2'
    lcall LCD_Put
	mov a, #'3'
    lcall LCD_Put
    mov a, #'0'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'2'
    lcall LCD_Put
	mov a, #'5'
    lcall LCD_Put
    mov a, #' '
    lcall LCD_Put
    mov a, #'6'
    lcall LCD_Put
	mov a, #'0'
    lcall LCD_Put
    
    jnb SWA.5, Continuing_b
    jb SWA.5, $
    
 	mov rampsoak+0, #65H	;165
	mov rampsoak+1, #01H
	mov preheat+0, #50H		;50
	mov preheat+1, #00H
	mov ramppeak+0, #30H	;230
	mov ramppeak+1, #02H
	mov reflow+0, #25H		;25
	mov reflow+1, #00H
	mov cooling+0, #60H		;60
	mov cooling+1, #00H
Continuing_b:
	ret

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;
	
DisplayTimerHEX:
   	mov dptr, #myLut  
	
	mov A, minutes
	swap a
	anl a, #0FH
	movc A, @A+dptr
	mov HEX7, a
	
    mov A, minutes
    anl a, #0FH
    movc A, @A+dptr
    mov HEX6, a
    ; Display Decimal
    mov A, seconds
    swap a
    anl a, #0FH
    movc A, @A+dptr
    mov HEX5, a
    ; Display Digit 0
    mov A, seconds
    anl a, #0FH
    movc A, @A+dptr
    mov HEX4, a
    ret
  
$LIST
