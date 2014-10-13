$NOLIST

CSEG

Counter_Timer:
	;Save used register into the stack
    push psw
    push acc
    push dph
    push dpl
    
    ;Increment the counter and check if a second has passed
    inc count10ms
    mov a, count10ms

	cjne A, #50, _1000ms
	
	mov a, short_beep
    add a, #1
    da a
    mov short_beep, a
    mov a, short_beep

_1000ms:
    cjne A, #100, ISR_Timer0_L0
    mov count10ms, #0
    
    mov a, short_beep
    add a, #1
    da a
    mov short_beep, a
    mov a, short_beep
    
    ;Seconds_counter
    mov a, seconds_counter+0
    add a, #1
    da a
    mov seconds_counter+0, a
    
    ;Counts from 0 to 250 and then resets to 0
    cjne a, #51H, Skip1_Seconds_Counter
    mov a, seconds_counter+1
    cjne a, #02H, Skip1_Seconds_Counter
    mov seconds_counter+1, #0
    mov seconds_counter+0, #0
    sjmp Continue_Seconds_Counter
    
Skip1_Seconds_Counter:
 	mov a, seconds_counter+0
 	cjne a, #00H, Check_Next_Seconds_Counter
 	mov a, seconds_counter+1
 	cjne a, #00H, Check_Next_Seconds_Counter
 
    mov a, seconds_counter+1
    add a, #1
    da a
    mov seconds_counter+1, a
    sjmp Continue_Seconds_Counter
    
Check_Next_Seconds_Counter:
	mov a, seconds_counter+0
	cjne a, #00H, Continue_Seconds_Counter
	mov a, seconds_counter+1
	cjne a, #01H, Continue_Seconds_Counter
 
 	mov a, seconds_counter+1
    add a, #1
    da a
    mov seconds_counter+1, a

Continue_Seconds_Counter:
    ;Timer_seconds
    mov a, timer_seconds+0
    add a, #1
    da a
    mov timer_seconds+0, a
    mov a, timer_seconds+0
      
    mov a, timer_seconds+0
    cjne A, #00H, Continue_Seconds
    
    mov a, timer_seconds+1
    add a, #1
    da a
    mov timer_seconds+1, a
    
Continue_Seconds: 
    mov a, seconds
    add a, #1
    da a
    mov seconds, a
    
    mov a, seconds
    cpl P0.2
    cjne A, #60H, ISR_Timer0_L0
    mov seconds, #0

    mov a, minutes
    add a, #1
    da a
    mov minutes, a
    cjne A, #60H, ISR_Timer0_L0
    mov minutes, #0
 
ISR_Timer0_L0:
	;Restore used registers
	pop dpl
	pop dph
	pop acc
	pop psw
	ret

$LIST
