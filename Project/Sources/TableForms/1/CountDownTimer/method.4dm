//FM: CountDownTimer() -> 
//@author mlb - 4/9/02  11:18

Case of 
	: (Form event code:C388=On Timer:K2:25)
		tTime:=tEnd-Current time:C178
		If (fBeep)  //do this one time
			If (tTime<?00:00:02?)
				BEEP:C151
				BEEP:C151
				fBeep:=False:C215
				$blackOnWhite:=-(Red:K11:4+(256*Black:K11:16))
				Core_ObjectSetColor(->tTime; $blackOnWhite)
			End if 
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		SET TIMER:C645(60*5)
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 