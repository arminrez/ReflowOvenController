$NOLIST

CSEG

;Set and clear green LEDs
Set_LEDG:
  setb LEDG.0
  setb LEDG.1
  setb LEDG.2
  setb LEDG.3
  setb LEDG.4
  setb LEDG.5
  ret

Clr_LEDG:
  clr LEDG.0
  clr LEDG.1
  clr LEDG.2
  clr LEDG.3
  clr LEDG.4
  clr LEDG.5
  ret

ClearLEDs:
	mov LEDRA,#0
	mov LEDRB,#0
	mov LEDRC,#0
	mov LEDG,#0	
	ret

ClearHEX:
	mov HEX0, #11111111B
	mov HEX1, #11111111B
	mov HEX2, #11111111B
	mov HEX3, #11111111B
	mov HEX4, #11111111B
	mov HEX5, #11111111B
	mov HEX6, #11111111B
	mov HEX7, #11111111B
	ret

;sends to serial port
SendString:
    CLR A
    MOVC A, @A+DPTR
    JZ SSDone
    LCALL SendSymbol
    INC DPTR
    sjmp SendString
SSDone:
    ret
    
SendSymbol:
    CLR TI			;Be sure the bit is initially clear
	MOV SBUF,a		;Send the letter A to the serial port
	JNB TI,$		;Pause until the TI bit is set. 
	ret
    
$LIST
