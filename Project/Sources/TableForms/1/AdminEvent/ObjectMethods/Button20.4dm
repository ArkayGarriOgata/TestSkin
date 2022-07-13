
If (Current user:C182="Designer")
	uConfirm("Overlay aMs bins with Rama Count"; "Yes"; "No")
	If (ok=1)
		Rama_Physical_Inventory
	End if 
Else 
	BEEP:C151
	ALERT:C41("Not Designer ehh?")
End if 
