If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	BEEP:C151
	uConfirm("Last jobform, "+sJobForm+", was not Set."; "Go Back"; "Ignor")
	If (ok=1)
		//goback
		
	Else 
		CANCEL:C270
		sJobForm:=""
	End if 
Else 
	CANCEL:C270
	sJobForm:=""
End if 