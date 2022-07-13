If (Current user:C182="Designer") | (Current user:C182="Administrator")
	uConfirm("Send P&G inventory data to remote db?"; "Yes"; "No")
	If (ok=1)
		CUSTPORT_WMS("png_inventory")
	End if 
Else 
	BEEP:C151
	uConfirm("Not Designer or Administrator, ehh?"; "Ohh"; "Well then")
End if 

