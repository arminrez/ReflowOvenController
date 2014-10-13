$NOLIST

CSEG

Display_RoomTemp:
	mov a, bcd+1
	anl a, #0FH
	movc a, @a+dptr
	lcall LCD_put

	mov a, bcd+0
	swap a
	anl a, #0FH
	movc a, @a+dptr
	lcall LCD_put
	
	mov a, bcd+0
	anl a, #0FH
	movc a, @a+dptr
	lcall LCD_put 
	ret
	
Display_OvenTemp:
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
	ret


Display_RampSoak:
 	;Digit 0
	mov a, rampsoak+0
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX1, a
 	;Digit 2
 	mov a, rampsoak+1
 	anl a, #0FH
 	cjne a, #0, Hundreds_Not_Zero
 	mov HEX3, #0FFH
 	sjmp Tens_Digit
Hundreds_Not_Zero:
 	movc a, @a+dptr
 	mov HEX3, a
 
Tens_Digit:
 	;Digit 1
 	mov a, rampsoak+0
 	swap a
 	anl a, #0FH
 	cjne a, #0, Tens_Not_Zero
 
 	mov a, rampsoak+1
 	anl a, #0FH
 	cjne a, #0, Tens_Not_Zero
 	mov HEX2, #0FFH
 	ljmp Display_End0
 
Tens_Not_Zero:
 	mov a, rampsoak+0
 	swap a
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX2, a
Display_End0:
    mov HEX0, #11000110B
    ret


Display_Preheat:
	;Digit 0
	mov a, preheat+0
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX0, a
 	;Digit 2
 	mov a, preheat+1
 	anl a, #0FH
 	cjne a, #0, Hundreds_Not_Zero1
 	mov HEX2, #0FFH
 	sjmp Tens_Digit1
Hundreds_Not_Zero1:
 	movc a, @a+dptr
 	mov HEX2, a
 
Tens_Digit1:
 	;Digit 1
 	mov a, preheat+0
 	swap a
 	anl a, #0FH
 	cjne a, #0, Tens_Not_Zero1
 
 	mov a, preheat+1
 	anl a, #0FH
 	cjne a, #0, Tens_Not_Zero1
 	mov HEX1, #0FFH
 	ljmp Display_End1
 
Tens_Not_Zero1:
 	mov a, preheat+0
 	swap a
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX1, a
Display_End1:
    mov HEX3, #0FFH
    ret

    
Display_RampPeak:
	;Digit 0
	mov a, ramppeak+0
	anl a, #0FH
	movc a, @a+dptr
	mov HEX1, a
	;Digit 2
	mov a, ramppeak+1
	anl a, #0FH
	cjne a, #0, Hundreds_Not_Zero2
	mov HEX3, #0FFH
	sjmp Tens_Digit2
Hundreds_Not_Zero2:
 	movc a, @a+dptr
 	mov HEX3, a
 
Tens_Digit2:
	;Digit 1
	mov a, ramppeak+0
	swap a
	anl a, #0FH
	cjne a, #0, Tens_Not_Zero2
	 
	mov a, ramppeak+1
	anl a, #0FH
	cjne a, #0, Tens_Not_Zero2
	mov HEX2, #0FFH
	ljmp Display_End2
 
Tens_Not_Zero2:
 	mov a, ramppeak+0
 	swap a
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX2, a 
Display_End2:
    mov HEX0, #11000110B
    ret


Display_Reflow:
	;Digit 0
	mov a, reflow+0
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX0, a
 	;Digit 2
	mov a, reflow+1
 	anl a, #0FH
 	cjne a, #0, Hundreds_Not_Zero3
 	mov HEX2, #0FFH
 	sjmp Tens_Digit3
Hundreds_Not_Zero3:
 	movc a, @a+dptr
 	mov HEX2, a
 
Tens_Digit3:
 	;Digit 1
 	mov a, reflow+0
 	swap a
 	anl a, #0FH
 	cjne a, #0, Tens_Not_Zero3
 
	mov a, reflow+1
 	anl a, #0FH
 	cjne a, #0, Tens_Not_Zero3
 	mov HEX1, #0FFH
 	ljmp Display_End3
 
Tens_Not_Zero3:
 	mov a, reflow+0
 	swap a
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX1, a 
Display_End3:
 	mov HEX3, #0FFH
 	ret
 	

Display_Cooling:
 	;Digit 0
 	mov a, cooling+0
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX1, a
 	;Digit 2
 	mov a, cooling+1
 	anl a, #0FH
 	cjne a, #0, Hundreds_Not_Zero4
 	mov HEX3, #0FFH
 	sjmp Tens_Digit4
Hundreds_Not_Zero4:
 	movc a, @a+dptr
 	mov HEX3, a
 
Tens_Digit4:
 	;Digit 1
 	mov a, cooling+0
 	swap a
 	anl a, #0FH
 	cjne a, #0, Tens_Not_Zero4
 
 	mov a, cooling+1
 	anl a, #0FH
 	cjne a, #0, Tens_Not_Zero4
 	mov HEX2, #0FFH
 	ljmp Display_End4
 
Tens_Not_Zero4:
 	mov a, cooling+0
 	swap a
 	anl a, #0FH
 	movc a, @a+dptr
 	mov HEX2, a 
Display_End4:
 	mov HEX0, #11000110B
 	ret
 	
$LIST
