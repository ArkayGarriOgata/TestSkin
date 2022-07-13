If (sVerifyLocation(Self:C308))
	
	If (RMB_isBinOccupied(sCriterion4))
		BEEP:C151
		ALERT:C41("WARNING: "+sCriterion4+" is not an empty Location"; "Continue")
	End if 
	
Else 
	BEEP:C151
End if 