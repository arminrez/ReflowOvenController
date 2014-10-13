; Reflow_Oven_Controller.asm:
; Controls oven for reflow soldering
; 
; To set time/temperature:
; - Key 3 goes to "Set" where each time/temperature can be configured
; - Key 1 (in Set mode) increments set time/temperature
; - Presets: SW7 and SW6 displays presets of variables, flip SW5 to select the preset
;
; To run reflow oven:
; - Key 2 goes to "Ready - Run" state
; - Key 1 (in run mode) to begin the reflow oven controlling process
; - To stop the process, press Key 3 to go back to selection menu
; 
; Extra:
; - SW3 - View "Room Temperature" in "Fahrenheit"
; - SW2 - View "Room Temperature" in "Kelvin"
; - SW1 - View "Oven Temperature" in "Fahrenheit"
; - SW0 - View "Oven Temperature" in "Kelvin"

$MODDE2

org 0000H
	ljmp MyProgram
	
org 000BH
	ljmp ISR_Timer0

org 001BH
	ljmp ISR_Timer1

CE_ADC	EQU P0.3
SCLK	EQU P0.2
MOSI	EQU P0.1
MISO	EQU P0.0

PWMPIN	EQU P1.5 	;PWM output pin

RUNLED	EQU P0.4 	;Pin for extra LEDs

XTAL			EQU 33333333
FREQ_1			EQU 2000
FREQ			EQU 100
TIMER0_RELOAD	EQU 65538-(XTAL/(12*FREQ))
TIMER1_RELOAD	EQU 65536-(XTAL/(12*2*FREQ_1))

BAUD	EQU 115200
T2LOAD	EQU 65536-(XTAL/(32*BAUD))

DSEG at 30H
count10ms:			ds 1
timer_seconds:		ds 2
seconds:			ds 1
seconds_counter:	ds 2
minutes:			ds 1

short_beep:			ds 1
long_beep:			ds 1
six_beep:			ds 1
	
x:					ds 4
y:					ds 4
bcd:				ds 5

x_oven:				ds 4
y_oven:				ds 4
bcd_oven:			ds 5

x_led:				ds 4
y_led:				ds 4

rampsoak:			ds 2
preheat:			ds 2
ramppeak:			ds 2
reflow:				ds 2
cooling:			ds 2

state:				ds 1
state_variable:		ds 1
checkingvariable:	ds 1

x_remainingtime:	ds 4
y_remainingtime:	ds 4
bcd_remainingtime:	ds 5

temperature:		ds 1
room_temp:			ds 4

power_20_percent:	ds 1
egg:				ds 1

seconds_storage:	ds 1
minutes_storage:	ds 1

BSEG
beep:				dbit 1
StartMode:			dbit 1

CSEG

$include(math32_modified.asm)
$include(Title_Menu.asm)
$include(Counter_and_Timer.asm)
$include(LCD_Functions_and_Displays.asm)	;Includes "Preset" functions
$include(LEDG.asm)					;This also includes sending symbols to serial port
$include(ADC_SPI.asm)
$include(pwm_control.asm)
$include(Display_Temperatures.asm)
$include(Useful_Delays.asm)
$include(ThermometerLED.asm)
$include(Initialization.asm) 	;Includes initializing pins, variables, and serial ports
$include(Six_Beeps.asm)
$include(EasterEgg.asm)

;Look-up table for 7-segment displays
myLUT:
    DB 0C0H, 0F9H, 0A4H, 0B0H, 099H
    DB 092H, 082H, 0F8H, 080H, 090H
    DB 0FFH 	;All segments off

myASCII:   ;Look-up table for 7-seg displays
    DB 30H, 31H, 32H, 33H, 34H					;0 TO 4
    DB 35H, 36H, 37H, 38H, 39H					; 4 TO 9

Hello_World:
    DB  '', '\r', '\n', 0

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

ISR_Timer0:
	push acc
	lcall PWM_Controller
	pop acc
	
	; Reload the timer
    mov TH0, #high(TIMER0_RELOAD)
    mov TL0, #low(TIMER0_RELOAD)
    
    lcall Counter_Timer
	reti
	
ISR_Timer1:
	jnb beep, Exit_Beep
	mov TH1, #high(TIMER1_RELOAD)
  	mov TL1, #low(TIMER1_RELOAD)
	cpl P3.6
Exit_Beep:
	reti
	
;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

Display_Temperature_Room:
	mov dptr, #myASCII  
	lcall Display_Roomtemp
	
	jnb SWA.2, Display_C1_Check			; Display F for Room Temperature with SW2
	mov a, #'F'
	sjmp PutLCD
	
Display_C1_Check:
	jnb SWA.3, Display_C1				; Display K for Room Temperature with SW3
	mov a, #'K'
	sjmp PutLCD
	
Display_C1:
	mov a, #'C'
PutLCD:
	lcall LCD_Put
	ret

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

Display_Temperature_Oven:
	mov dptr, #myASCII
	lcall Display_Oventemp	
	
	jnb SWA.0, Display_C2_Check 		; Display F for Oven Temperature with SW0
	mov a, #'F'
	sjmp PutLCD2
	
Display_C2_Check:
	jnb SWA.1, Display_C2 				; Display K for Oven Temperature with SW1
	mov a, #'K'
	sjmp PutLCD2
	
Display_C2:
	mov a, #'C'
PutLCD2:
	lcall LCD_Put
	ret

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

; Ramp Soak state
Display0:
	; For Displaying Time
	mov dptr, #myLUT
	lcall Display_Rampsoak
 	ret

; Preheat state
Display1:
	; For Displaying Time
	mov dptr, #myLUT
	lcall Display_Preheat
 	ret

; Ramp Peak state
Display2:
	; For Displaying Time
	mov dptr, #myLUT
	lcall Display_Ramppeak
 	ret
 
; Reflow state
Display3:
	; For Displaying Time
 	mov dptr, #myLUT
	lcall Display_Reflow
 	ret
 
;Cooling state
Display4:
 ; For Displaying Time
 	mov dptr, #myLUT
	lcall Display_Cooling
 	ret

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

Thermometer_LED:
	lcall SetLED_Pins
	lcall Thermometer_LED_Lighting
	ret

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

MyProgram:
	mov SP, #7FH
	lcall ClearLEDs
		
	lcall LCD ; initialize LCD screen
		
	lcall ClearScreen
	lcall TitleScreen
		
	mov state_variable, #0 		; prevents reflow oven to run automatically at start
	
	lcall InitPins
	lcall InitVariables
	lcall InitSerialPort
	lcall Init_Timer1
	lcall Init_Timer0
	lcall Init_SPI
    setb EA  			; Enable all interrupts
    
	mov a, StartMode		; 1=Set, 0=Run
	cjne a, #0, Set_Mode_Forever	; To set
	ljmp Forever_Prerun		; To run

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

;Set Mode pre-loop
Set_Mode_Forever:
	lcall ClearLEDs
	lcall ClearHEX
	clr beep
	mov state_variable, #0
	ljmp Set_Forever

Forever_Run_Temp:
	ljmp Forever_Prerun

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

;Set Mode - State Machines
Set_Forever:
	lcall SPI_Connection		; Reads temperature
	lcall Thermometer_LED
	clr LEDG.0
	clr RUNLED

	jnb KEY.2, Forever_Run_Temp		; KEY 2 -> change to run mode

Set_Mode_State_Machine:
	mov a, state
	sjmp State0

TempState1:
	ljmp State1		; Bridge [relative offset] for jumping to state1 (for state0)
	
State0:
	cjne a, #0, TempState1
 	lcall Display0
 
 	jb SWA.7, SkipLCDNormal01
 	jb SWA.6, SkipLCDNormal02
 	lcall DisplayTimeLCD_State0
 	lcall Display_Set
 	ljmp Continuing0
 	
SkipLCDNormal01:
 	lcall ClearScreen
 	lcall ShowPreset	
 	lcall Preset1
 	ljmp Continuing0
 	
SkipLCDNormal02:
 	lcall ClearScreen
 	lcall ShowPreset
 	lcall Preset2
 	ljmp Continuing0

Continuing0:

Set_Time0:
 	jb KEY.1, Next_Key0
    
    mov a, rampsoak+0
    add a, #1
    da a
    mov rampsoak+0, a
    
    cjne a, #51H, Skip0
    mov a, rampsoak+1
    cjne a, #02H, Skip0
    mov rampsoak+1, #0
    mov rampsoak+0, #0
    
    sjmp Next_Key0
Skip0:
	mov a, rampsoak+0
	cjne a, #00H, Check_Next0
 	mov a, rampsoak+1
 	cjne a, #00H, Check_Next0
 
    mov a, rampsoak+1
    add a, #1
    da a
    mov rampsoak+1, a
    
    sjmp Next_Key0
Check_Next0:
	mov a, rampsoak+0
 	cjne a, #00H, Next_Key0
 	mov a, rampsoak+1
 	cjne a, #01H, Next_Key0  
 
	mov a, rampsoak+1
    add a, #1
    da a
    mov rampsoak+1, a
    
    sjmp Next_Key0
Next_Key0:
 	jb KEY.3, State0_Done
 	jnb KEY.3, $ 		; Wait for key release
 	mov state, #1
State0_Done:
	ljmp Set_Forever
 

State1:
 	cjne a, #1, State2
 	lcall Display1

 	jb SWA.7, SkipLCDNormal11
 	jb SWA.6, SkipLCDNormal12
 	lcall DisplayTimeLCD_State1
 	lcall Display_Set
 	ljmp Continuing1
 	
SkipLCDNormal11:
 	lcall ClearScreen
 	lcall ShowPreset	
 	lcall Preset1
 	ljmp Continuing1
 	
SkipLCDNormal12:
 	lcall ClearScreen
 	lcall ShowPreset
 	lcall Preset2
 	ljmp Continuing1

Continuing1:

Set_Time1:
 	jb KEY.1, Next_Key1
    
 	mov a, preheat+0
    add a, #1
    da a
    mov preheat+0, a
    
    cjne a, #51H, Skip1_
    mov a, preheat+1
    cjne a, #02H, Skip1_
    mov preheat+1, #0
    mov preheat+0, #0
    
    sjmp Next_Key1
Skip1_:
 	mov a, preheat+0
 	cjne a, #00H, Check_Next1
 	mov a, preheat+1
 	cjne a, #00H, Check_Next1
 
    mov a, preheat+1
    add a, #1
    da a
    mov preheat+1, a
    
    sjmp Next_Key1
Check_Next1:
 	mov a, preheat+0
 	cjne a, #00H, Next_Key1
 	mov a, preheat+1
 	cjne a, #01H, Next_Key1  
 
 	mov a, preheat+1
    add a, #1
    da a
    mov preheat+1, a
    
    sjmp Next_Key1
Next_Key1: 
 	jb KEY.3, State1_Done
 	jnb KEY.3, $ 		; Wait for key release
 	mov state, #2
State1_Done:
 	ljmp Set_Forever


State2:
 	cjne a, #2, State3
 	lcall Display2
 
 	jb SWA.7, SkipLCDNormal21
 	jb SWA.6, SkipLCDNormal22
 	lcall DisplayTimeLCD_state2
 	lcall Display_Set
 	ljmp Continuing2
 	
SkipLCDNormal21:
 	lcall ClearScreen
 	lcall ShowPreset	
 	lcall Preset1
 	ljmp Continuing2
 	
SkipLCDNormal22:
 	lcall ClearScreen
 	lcall ShowPreset
 	lcall Preset2
 	ljmp Continuing2

Continuing2:
 
Set_Time2:
 	jb KEY.1, Next_Key2
    
 	mov a, ramppeak+0
    add a, #1
    da a
    mov ramppeak+0, a
    
    cjne a, #51H, Skip2_
    mov a, ramppeak+1
    cjne a, #02H, Skip2_
    mov ramppeak+1, #0
    mov ramppeak+0, #0
    
    sjmp Next_Key2
Skip2_:
 	mov a, ramppeak+0
 	cjne a, #00H, Check_Next2
 	mov a, ramppeak+1
 	cjne a, #00H, Check_Next2
 
    mov a, ramppeak+1
    add a, #1
    da a
    mov ramppeak+1, a
    
    sjmp Next_Key2
Check_Next2:
 	mov a, ramppeak+0
 	cjne a, #00H, Next_Key2
 	mov a, ramppeak+1
 	cjne a, #01H, Next_Key2  
 
 	mov a, ramppeak+1
    add a, #1
    da a
    mov ramppeak+1, a
    
    sjmp Next_Key2
Next_Key2:
 	jb KEY.3, State2_Done
 	jnb KEY.3, $ 		; Wait for key release
 	mov state, #3
State2_Done:
 	ljmp Set_Forever
 
 
State3:
 	cjne a, #3, State4
 	lcall Display3
 
 	jb SWA.7, SkipLCDNormal31
 	jb SWA.6, SkipLCDNormal32
 	lcall DisplayTimeLCD_State3
 	lcall Display_Set
 	ljmp Continuing3
 	
SkipLCDNormal31:
 	lcall ClearScreen
 	lcall ShowPreset	
 	lcall Preset1
 	ljmp Continuing3
 	
SkipLCDNormal32:
 	lcall ClearScreen
 	lcall ShowPreset
 	lcall Preset2
 	ljmp Continuing3

Continuing3:
 
Set_Time3:
 	jb KEY.1, Next_Key3
    
 	mov a, reflow+0
    add a, #1
    da a
    mov reflow+0, a
    
    cjne a, #51H, Skip3_
    mov a, reflow+1
    cjne a, #02H, Skip3_
    mov reflow+1, #0
    mov reflow+0, #0
    
    sjmp Next_Key3
Skip3_:
 	mov a, reflow+0
 	cjne a, #00H, Check_Next3
 	mov a, reflow+1
 	cjne a, #00H, Check_Next3
 
    mov a, reflow+1
    add a, #1
    da a
    mov reflow+1, a
    
    sjmp Next_Key3
Check_Next3:
 	mov a, reflow+0
 	cjne a, #00H, Next_Key3
 	mov a, reflow+1
 	cjne a, #01H, Next_Key3  
 
 	mov a, reflow+1
    add a, #1
    da a
    mov reflow+1, a
    
    sjmp Next_Key3
Next_Key3:
 	jb KEY.3, State3_Done
 	jnb KEY.3, $ 		; Wait for key release
 	mov state, #4
State3_Done:
 	ljmp Set_Forever

 
State0Temp:			; Bridge [relative offset] back to State0 (for State4)
 	ljmp State0


State4:
 	cjne a, #4, State0Temp
 	lcall Display4
 
 	jb SWA.7, SkipLCDNormal41
 	jb SWA.6, SkipLCDNormal42
 	lcall DisplayTimeLCD_State4
 	lcall Display_Set
 	ljmp Continuing4
 	
SkipLCDNormal41:
 	lcall ClearScreen
 	lcall ShowPreset	
 	lcall Preset1
 	ljmp Continuing4
 	
SkipLCDNormal42:
 	lcall ClearScreen
 	lcall ShowPreset
 	lcall Preset2
 	ljmp Continuing4

Continuing4:
 
Set_Time4:
 	jb KEY.1, Next_Key4
    
 	mov a, cooling+0
    add a, #1
    da a
    mov cooling+0, a
    
    cjne a, #51H, Skip4_
    mov a, cooling+1
    cjne a, #02H, Skip4_
    mov cooling+1, #0
    mov cooling+0, #0
    
    sjmp Next_Key4
Skip4_:
 	mov a, cooling+0
 	cjne a, #00H, Check_Next4
 	mov a, cooling+1
 	cjne a, #00H, Check_Next4
 
    mov a, cooling+1
    add a, #1
    da a
    mov cooling+1, a
    
    sjmp Next_Key4
Check_Next4:
 	mov a, cooling+0
 	cjne a, #00H, Next_Key4
 	mov a, cooling+1
 	cjne a, #01H, Next_Key4  
 
 	mov a, cooling+1
    add a, #1
    da a
    mov cooling+1, a
    
    sjmp Next_Key4
Next_Key4: 
 	jb KEY.3, State4_Done
 	jnb KEY.3, $ ; Wait for key release
 	mov state, #0
State4_Done:
 	ljmp Set_Forever
 
;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

JumpForever:			; Bridge [relative offset]
	clr RUNLED
	lcall ClearLEDs
	ljmp Set_Mode_Forever
	
Beep_EndTemp:			; Bridge [relative offset]
	ljmp Beep_End

;Ready State (Run Mode)
Ready_State_Forever:
 	lcall SPI_Connection	; Read temperature
 	lcall Thermometer_LED
 	lcall EasterEgg			; Check if easter egg is toggled
  
 	clr RUNLED
 	mov a, state_variable
    jnb KEY.3, JumpForever	; Stop button
 	push AR5				; Popped in beep_x6
 	cjne R5, #0, Beep_EndTemp
	
  	mov R6, six_beep		; Six_beep controls off and on of the beeper
  	cjne R6, #0, Beep_Six_Times
 	setb beep
 	lcall Set_LEDG			; To flash green LED with beeper
 	inc six_beep

Beep_Six_Times:
  	lcall Beep_x6
  	ljmp Continue_Forever_Run
 
;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

Stop_Process:
	mov state_variable, #0 	; Turns off oven
	ljmp Select_StartMode 	; Go to menu

;;;;;;;;;;;;;;;;; ~seperator~ ;;;;;;;;;;;;;;;;;

;Run mode - State Machines
Forever_Prerun:
 	mov state_variable, #0
 	lcall ClearHEX

Forever_Run:
 	mov R2, #1
 	lcall SPI_Connection

No_SPI_Forever_Run:			; Skips reading temperature => no delay
 	lcall Thermometer_LED
 	cpl RUNLED
 
 	mov R6, short_beep		; After each state ends, sets to 3 or 4
 	cjne R6, #5, Continue_Forever_Run;Once it hits 5 (increments every second), beep stops
 	clr beep
 
Continue_Forever_Run:
	mov a, state_variable
 	jnb KEY.3, Stop_Process		; Stop button

Ready_State:
 	cjne a, #0, Rampsoak_State
 	lcall DisplayTimeLCD_State_Ready
 	lcall Display_Run
 	
 	mov HEX2, #0FFH
 	mov HEX1, #0FFH
 	mov HEX0, #0FFH
 	
 	jb KEY.1, Ready_State_Done
 	jnb KEY.1, $ 	; Wait for key release
 	
 	mov state_variable, #1
 	mov short_beep, #3			; First beep is longer (begins running)
 	setb beep
 	
 	mov timer_seconds+0, #00H
 	mov timer_seconds+1, #0
 	mov seconds_counter+0, #00H
 	mov seconds_counter+1, #0
 	mov seconds, #0
 	mov minutes, #0
 	
 	setb LEDG.0
 	ljmp No_SPI_Forever_Run
Ready_State_Done:
 	ljmp Ready_State_Forever

 
Rampsoak_State:
 	cjne a, #1, Preheat_State
 	lcall DisplayTimeLCD_State0
 	lcall Display_Run
 	
 	mov x_remainingtime+0, rampsoak+0
 	mov x_remainingtime+1, rampsoak+1
 	mov x_remainingtime+2, #0
 	mov x_remainingtime+3, #0
 	mov y_remainingtime+0, bcd_Oven+0
 	mov y_remainingtime+1, bcd_Oven+1
 	mov y_remainingtime+2, #0
	mov y_remainingtime+3, #0
 	lcall sub32_remainingtime
 	lcall DisplayHEX0to2 		; Displaying run time
 	
 	mov a, x_remainingtime+1
 	cjne a, #0, Rampsoak_State_Done
 	mov a, x_remainingtime+0
 	cjne a, #0, Rampsoak_State_Done
 	
 	mov state_variable, #2
 	mov short_beep, #4
 	setb beep
 	
 	mov timer_seconds+0, #0
 	mov timer_seconds+1, #0
 	mov seconds_counter+0, #0
 	mov seconds_counter+1, #0
 	
 	setb LEDG.1
 	ljmp No_SPI_Forever_Run
Rampsoak_State_Done:
 	ljmp Forever_Run
 
 
Preheat_State:
 	cjne a, #2, Ramppeak_State
 	lcall DisplayTimeLCD_State1
 	lcall Display_Run
 	
 	mov x_remainingtime+0, preheat+0
 	mov x_remainingtime+1, preheat+1
 	mov y_remainingtime+0, timer_seconds+0
 	mov y_remainingtime+1, timer_seconds+1
 	lcall sub32_remainingtime
 	lcall DisplayHEX0to2
 	
 	mov a, x_remainingtime+1
 	cjne a, #0, Preheat_State_Done
 	mov a, x_remainingtime+0
 	cjne a, #0, Preheat_State_Done
 	
 	mov state_variable, #3
 	mov short_beep, #4
 	setb beep
 	
 	mov timer_seconds+0, #0
 	mov timer_seconds+1, #0
 	mov seconds_counter+0, #0
 	mov seconds_counter+1, #0
 	
 	setb LEDG.2
 	ljmp No_SPI_Forever_Run
Preheat_State_Done:
 	ljmp Forever_Run
 
 
Ramppeak_State:
 	cjne a, #3, Reflow_State
 	lcall DisplayTimeLCD_State2
 	lcall Display_Run
 	
 	mov x_remainingtime+0, ramppeak+0
 	mov x_remainingtime+1, ramppeak+1
 	mov y_remainingtime+0, bcd_Oven+0
 	mov y_remainingtime+1, bcd_Oven+1
 	lcall sub32_remainingtime
 	lcall DisplayHEX0to2
 	
 	mov a, x_remainingtime+1
 	cjne a, #0, Ramppeak_State_Done
 	mov a, x_remainingtime+0
 	cjne a, #0, Ramppeak_State_Done
 	
 	mov state_variable, #4
 	mov short_beep, #4
 	setb beep
 	
 	mov timer_seconds+0, #0
 	mov timer_seconds+1, #0
 	mov seconds_counter+0, #0
 	mov seconds_counter+1, #0
 	
 	setb LEDG.3
 	ljmp No_SPI_Forever_Run
Ramppeak_State_Done:
 	ljmp Forever_Run

 
Reflow_State:
 	cjne a, #4, Cooling_State
 	lcall DisplayTimeLCD_State3
 	lcall Display_Run
 	
 	mov x_remainingtime+0, reflow+0
 	mov x_remainingtime+1, reflow+1
 	mov y_remainingtime+0, timer_seconds+0
 	mov y_remainingtime+1, timer_seconds+1
 	lcall sub32_remainingtime
 	lcall DisplayHEX0to2
 	
 	mov a, x_remainingtime+1
 	cjne a, #0, Reflow_State_Done
 	mov a, x_remainingtime+0
 	cjne a, #0, Reflow_State_Done
 	
 	mov state_variable, #5
 	mov short_beep, #0
 	setb beep
 	
 	mov timer_seconds+0, #0
 	mov timer_seconds+1, #0
 	mov seconds_counter+0, #0
 	mov seconds_counter+1, #0
 	
 	setb LEDG.4
 	ljmp No_SPI_Forever_Run
Reflow_State_Done:
 	ljmp Forever_Run
 
 
Cooling_State:
 	cjne a, #5, Ready_State_Temp
 	lcall DisplayTimeLCD_State4
 	lcall Display_Run
 	
 	mov x_remainingtime+0, cooling+0
 	mov x_remainingtime+1, cooling+1
 	mov y_remainingtime+0, bcd_Oven+0
 	mov y_remainingtime+1, bcd_Oven+1
 	lcall sub32_remainingtime
 	lcall DisplayHEX0to2
 	
 	mov a, x_remainingtime+1
 	cjne a, #0, Cooling_State_Done
 	mov a, x_remainingtime+0
 	cjne a, #0, Cooling_State_Done
 	
 	mov state_variable, #0
 	mov timer_seconds+0, #0
 	mov timer_seconds+1, #0
 	
 	mov R5, #0
 	mov six_beep, #0
 	
 	setb LEDG.5
 	ljmp No_SPI_Forever_Run
Cooling_State_Done:
 	ljmp Forever_Run
 
Ready_State_Temp:			; Bridge [relative offset]
	ljmp Ready_State
  
END
