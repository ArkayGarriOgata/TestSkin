//OM: bOk() -> 
//@author mlb - 9/4/02  12:43

Case of 
	: (i0=1)
		If (vOrd=0)
			BEEP:C151
			ALERT:C41("Please enter the Order number to reference.")
			REJECT:C38
		End if 
		
	: (i2=1)
		If (vOrd=0)
			BEEP:C151
			ALERT:C41("Please enter the Order number to append.")
			REJECT:C38
		End if 
		
	: (i3=1)
		If (vOrd=0)
			BEEP:C151
			ALERT:C41("Please enter the Order number to apply charges too.")
			REJECT:C38
		End if 
End case 