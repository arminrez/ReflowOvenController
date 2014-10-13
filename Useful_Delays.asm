$NOLIST

CSEG

WaitHalfSec:
	push AR0
	push AR1
	push AR2
	mov R2, #33	; 33/90 of half a second - approximately 0.18sec
L3: mov R1, #250
L2: mov R0, #250
L1: djnz R0, L1 	;3 machine cycles-> 3*30ns*250=22.5us
	djnz R1, L2 	;22.5us*250=5.625ms
	djnz R2, L3 	;5.625ms*90=0.506s (approximately)
	pop AR0
	pop AR1
	pop AR2
	ret
	
Delay:
	mov R3, #20
Delay_loop:
	djnz R3, Delay_loop
	ret
	
WaitHalfSec2:
	push AR0
	push AR1
	push AR2
	mov R2, #33
L6: mov R1, #250
L5: mov R0, #250
L4: djnz R0, L4 	;3 machine cycles-> 3*30ns*250=22.5us
	djnz R1, L5 	;22.5us*250=5.625ms
	djnz R2, L6 	;5.625ms*90=0.506s (approximately)
	pop AR0
	pop AR1
	pop AR2
	ret
	
$LIST
