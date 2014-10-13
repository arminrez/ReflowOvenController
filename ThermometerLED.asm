$NOLIST

CSEG

;Non-DE2 LEDs
SetLED_Pins:
	;In case of garbage values
	mov y_led+2, #0
	mov y_led+3, #0
	
	;LED pins
	setb P2.0
	setb P2.1
	setb P2.2
	setb P2.3
	setb P2.4
	setb P2.5
	setb P2.6
	setb P2.7
	setb P3.2
	setb P3.3
	setb P3.4
	setb P3.5
	
	;Clear DE2 board LEDs
	mov LEDRA, #0
	mov LEDRB, #0
	mov LEDRC, #0
	ret


;Intervals of 20 degree celsius -> 1 light
;eg. If 25C, 1 light
;    If 65C, 3 lights

;Uses technique of "greater than" => 'bcd_oven > y_led'
Thermometer_LED_Lighting:
Celsius20:
	mov y_led+0, #20H
	mov y_led+1, #00H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_20
	sjmp Celsius40
	
Temperature_20:
	clr P2.1					; clr turns on light
	
Celsius40:
	mov y_led+0, #40H
	mov y_led+1, #00H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_40
	sjmp Celsius60
	
Temperature_40:
	clr P2.2

Celsius60:
	mov y_led+0, #60H
	mov y_led+1, #00H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_60
	sjmp Celsius80
	
Temperature_60:
	clr P2.3

Celsius80:
	mov y_led+0, #80H
	mov y_led+1, #00H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_80
	sjmp Celsius100
	
Temperature_80:
	clr P2.4

Celsius100:
	mov y_led+0, #00H
	mov y_led+1, #01H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_100
	sjmp Celsius120
	
Temperature_100:
	clr P2.5
	
Celsius120:
	mov y_led+0, #20H
	mov y_led+1, #01H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_120
	sjmp Celsius140
	
Temperature_120:
	clr P2.6

Celsius140:
	mov y_led+0, #40H
	mov y_led+1, #01H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_140
	sjmp Celsius160
	
Temperature_140:
	clr P2.7

Celsius160:
	mov y_led+0, #60H
	mov y_led+1, #01H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_160
	sjmp Celsius180
	
Temperature_160:
	clr P3.2

Celsius180:
	mov y_led+0, #80H
	mov y_led+1, #01H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_180
	sjmp Celsius200
	
Temperature_180:
	clr P3.3

Celsius200:
	mov y_led+0, #00H
	mov y_led+1, #02H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_200
	sjmp Celsius220
	
Temperature_200:
	clr P3.4
	mov LEDRA, #0FFH
	mov LEDRB, #0FFH
	mov LEDRC, #0FFH

Celsius220:
	mov y_led+0, #20H
	mov y_led+1, #02H
	clr c
	mov a, bcd_oven+0
	subb a, y_led+0
	mov a, bcd_oven+1
	subb a, y_led+1
	
	jnc Temperature_220
	sjmp Celsius220End
	
Temperature_220:
	clr P3.5

Celsius220End:
	ret

$LIST
