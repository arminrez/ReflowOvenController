$NOLIST

CSEG

Read_ADC_Channel:
	clr CE_ADC
	mov R0, #00000001B		; Start bit:1
	lcall DO_SPI_G
	
	mov a, b
	swap a
	anl a, #0F0H
	setb acc.7				; Single mode (bit 7).
	
	mov R0, a				;  Select channel
	lcall DO_SPI_G
	mov a, R1				; R1 contains bits 8 and 9
	anl a, #03H
	mov R6, a				; R6 contains bits 8 and 9
	
	mov R0, #55H			; It doesn't matter what we transmit...
	lcall DO_SPI_G
	mov a, R1				; R1 contains bits 0 to 7
	mov R1, a				; R1 contains bits 0 to 7
	setb CE_ADC
	ret
	
SPI_Connection:	
	mov b, #10000000B		; Room temperature LM335 temperature sensor is connected to channel 0
	
	lcall Read_ADC_Channel
	
	mov x+0, #0
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	
	mov x+0, R1
	mov x+1, R6
	
	Load_y(250)
	lcall mul32
	Load_y(512)
	lcall div32
	
	Load_y(273)
	lcall sub32

	mov room_temp+0, x+0
	mov room_temp+1, x+1
	mov room_temp+2, #0
	mov room_temp+3, #0
		
	lcall hex2bcd
	
	jnb SWA.2, Display_C0_Check
	
	;Convert to F	
	load_y(9)
	lcall mul32
	
	load_y(5)
	lcall div32
	
	load_y(32)
	lcall add32
	
	lcall hex2bcd
	ljmp Display_C0
	
Display_C0_Check:
	jnb SWA.3, Display_C0
	load_y(273)
	lcall add32
	
	lcall hex2bcd
	
Display_C0:

SPI_Connection_Oven:
	mov b, #1			; Oven temperature thermocouple is connected to channel 1
	
	lcall Read_ADC_Channel

	mov x_oven+0, R1
	mov x_oven+1, R6
	mov x_oven+2, #0
	mov x_oven+3, #0
	
	load_y_oven(25000)
	lcall mul32_oven
	
	load_y_oven(1023*41)
	lcall div32_oven

	mov y_oven+0, room_temp+0
	mov y_oven+1, room_temp+1
	mov y_oven+2, #0
	mov y_oven+3, #0
		
	lcall add32_oven
	
	lcall hex2bcd_oven
	
	jnb SWA.0, Display_C_Check
	
	;Convert to F
	load_y_oven(9)
	lcall mul32_oven
	
	load_y_oven(5)
	lcall div32_oven
	
	load_y_oven(32)
	lcall add32_oven
	
	lcall hex2bcd_oven
	ljmp Display_C
	
Display_C_Check:
	jnb SWA.1, Display_C
	load_y_oven(273)
	lcall add32_oven
	
	lcall hex2bcd_oven
	
Display_C:
	mov a, bcd_oven+1
	anl a, #0FH
	orl a, #30H
	lcall SendSymbol
	
	mov a, bcd_oven+0
	swap a
	anl a, #0FH
	orl a, #30H
	lcall SendSymbol
	
	mov a, bcd_oven+0
	anl a, #0FH
	orl a, #30H
	lcall SendSymbol
	
	clr a
	mov dptr, #Hello_World
	lcall SendString	
	lcall WaitHalfSec
	ret

$LIST
