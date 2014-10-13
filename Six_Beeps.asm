$NOLIST

CSEG

Beep_x6:
Beep1:
 	cjne R6, #1, Beep2
 	clr beep
  	lcall Clr_LEDG
  	inc six_Beep
Beep2:
  	cjne R6, #2, Beep3 
  	setb beep
  	lcall Set_LEDG
  	inc six_beep
Beep3:
  	cjne R6, #3, Beep4 
  	clr beep
  	lcall Clr_LEDG
  	inc six_beep
Beep4:
  	cjne R6, #4, Beep5
  	setb beep
  	lcall Set_LEDG
  	inc six_beep
Beep5:
  	cjne R6, #5, Beep6 
  	clr beep
  	lcall Clr_LEDG
  	inc six_beep
Beep6:
  	cjne R6, #6, Beep7
  	setb beep
  	lcall Set_LEDG
  	inc six_beep
Beep7:
  	cjne R6, #7, Beep8 
  	clr beep
  	lcall Clr_LEDG
  	inc six_beep
Beep8:
  	cjne R6, #8, Beep9 
  	setb beep
  	lcall Set_LEDG
  	inc six_beep
Beep9:
  	cjne R6, #9, Beep10 
  	clr beep
  	lcall Clr_LEDG
  	inc six_beep
Beep10:
  	cjne R6, #10, Beep11 
  	setb beep
  	lcall Set_LEDG
  	inc six_beep
Beep11:
  	cjne R6, #11, Beep_End
  	clr beep
  	lcall Clr_LEDG
  	inc six_beep
  	mov R5, #1
  
Beep_End:
  	pop AR5
  	ret

$LIST
