If (Abs:C99(rReal1)>2000000)
	BEEP:C151
	ALERT:C41("Alert: "+String:C10(rReal1)+" is too big. The quantity must be 2,000,000 or less.")
	rReal1:=0
	GOTO OBJECT:C206(rReal1)
End if 

If (False:C215)  //FX locations no longer used mlb 05/22/12
	$jobit:=JMI_makeJobIt(sCriterion5; i1)
	If (iMode=0)
		FGL_CalcFXamount($jobit)
	End if 
End if 