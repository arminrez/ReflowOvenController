$NOLIST

CSEG

InitSerialPort:
	clr TR2				; Disable Timer 2
	mov T2CON, #30H		; RCLK=1, TCLK=1 
	mov RCAP2H, #high(T2LOAD)  
	mov RCAP2L, #low(T2LOAD)
	setb TR2			; Enable Timer 2
	mov SCON, #52H
	ret

Init_Timer0:	
	mov TMOD,  #00010001B	; GATE=0, C/T*=0, M1=0, M0=1: 16-bit timer
	clr TR0				; Disable timer 0
	clr TF0
    mov TH0, #high(TIMER0_RELOAD)
    mov TL0, #low(TIMER0_RELOAD)
	setb EA
    setb TR0			; Enable timer 0
    setb ET0			; Enable timer 0 interrupt
    ret
    
Init_Timer1:	
	mov TMOD,  #00010001B	; GATE=0, C/T*=0, M1=0, M0=1: 16-bit timer
	clr TR1					; Disable Timer 1
	clr TF1
    mov TH1, #high(TIMER1_RELOAD)
    mov TL1, #low(TIMER1_RELOAD)  
    clr beep
    mov R7,#0
    setb TR1			; Enable Timer 1
    setb ET1			; Enable Timer 1 interrupt
    ret

INIT_SPI:
	orl P0MOD, #00110110B	; Set SCLK, MOSI as outputs
	anl P0MOD, #11111110B	; Set MISO as input
	clr SCLK				; For mode (0,0) SCLK is zero
	ret
DO_SPI_G:
	push acc
	mov R1, #0 				; Received byte stored in R1
	mov R2, #8 				; Loop counter (8-bits)
DO_SPI_G_LOOP:
	mov a, R0 				; Byte to write is in R0
	rlc a 					; Carry flag has bit to write
	mov R0, a
	mov MOSI, c
	setb SCLK 				; Transmit
	mov c, MISO 			; Read received bit
	mov a, R1 				; Save received bit in R1
	rlc a
	mov R1, a
	clr SCLK
	djnz R2, DO_SPI_G_LOOP
	pop acc
	ret

InitPins:
	mov P0MOD, #00011111B 	; ADC
	setb P0.0
	
	mov P1MOD, #00100000B 	; PWM pin
	mov P2MOD, #11111111B 	; For LED Lights
	mov P3MOD, #11111110B 	; P3.6, P3.7 are outputs for beeper!
	ret

InitVariables:
	mov short_beep, #30
	mov state, #0
	
	mov minutes, #00H
	mov seconds, #00H
	
	mov timer_seconds+0, #00H
	mov timer_seconds+1, #00H
	mov rampsoak+0, #60H	; 160
	mov rampsoak+1, #01H
	mov preheat+0, #60H		; 60
	mov preheat+1, #00H
	mov ramppeak+0, #20H	; 220
	mov ramppeak+1, #02H
	mov reflow+0, #40H		; 40
	mov reflow+1, #00H
	mov cooling+0, #60H		; 60
	mov cooling+1, #00H

	mov bcd_remainingtime+0, #0H
	mov bcd_remainingtime+1, #0H
	mov bcd_remainingtime+2, #0H
	mov bcd_remainingtime+3, #0H
	mov bcd_remainingtime+4, #0H
	
	mov R5, #1
	mov checkingvariable, #1
	
	mov power_20_percent, #0
	ret

$LIST
