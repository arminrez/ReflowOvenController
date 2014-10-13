$NOLIST

CSEG

PWM_Controller:
	mov a, state_variable

Ready_Off:
	cjne a, #0, Ramp_Soak_On
	clr PWMPIN						;Make PWM output pin low
	ljmp OutPWM
	
Ramp_Soak_On:
	cjne a, #1, Pre_Heat_On
	setb PWMPIN						;Make PWM output pin High
	mov power_20_percent, #0
	ljmp OutPWM
	
Pre_Heat_On:
	cjne a, #2, Ramp_to_Peak_On
	push acc
	mov a, power_20_percent
	
OvenOff:
	cjne a, #0, OvenOff2
	clr PWMPIN
	mov power_20_percent, #1
	sjmp EndOven
OvenOff2:
	cjne a, #1, OvenOff3
	clr PWMPIN
	mov power_20_percent, #2
	sjmp EndOven
OvenOff3:	
	cjne a, #2, OvenOff4
	clr PWMPIN
	mov power_20_percent, #3
	sjmp EndOven
OvenOff4:
	cjne a, #3, OvenOn
	clr PWMPIN
	mov power_20_percent, #4
	sjmp EndOven
OvenOn:
	cjne a, #4, EndOven
	setb PWMPIN
	mov power_20_percent, #0
EndOven:
	pop acc
	ljmp OutPWM
	
Ramp_to_Peak_On:
	cjne a, #3, Reflow_On
	Setb PWMPIN						; Make PWM output pin High
	mov power_20_percent, #0
	ljmp OutPWM
	
Reflow_On:
	cjne a, #4, Cooling_Off
	
	push acc
	mov a, power_20_percent
	
Oven_Off:
	cjne a, #0, Oven_Off2
	clr PWMPIN
	mov power_20_percent, #1
	sjmp End_Oven
Oven_Off2:
	cjne a, #1, Oven_Off3
	clr PWMPIN
	mov power_20_percent, #2
	sjmp End_Oven
Oven_Off3:	
	cjne a, #2, Oven_Off4
	clr PWMPIN
	mov power_20_percent, #3
	sjmp End_Oven
Oven_Off4:
	cjne a, #3, Oven_On
	clr PWMPIN
	mov power_20_percent, #4
	sjmp End_Oven
Oven_On:
	cjne a, #4, End_Oven
	setb PWMPIN
	mov power_20_percent, #0
End_Oven:
	pop acc
	ljmp OutPWM
	
Cooling_Off:
	clr PWMPIN						;Make PWM output pin low
	ljmp OutPWM

OutPWM:
	ret
	
$LIST
