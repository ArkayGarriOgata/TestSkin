If (Current user:C182="Designer") | (Current user:C182="Administrator")
	uConfirm("Import transactions from WMS here instead of on BatchMac?"; "Yes"; "No")
	If (ok=1)
		wms_api_Get_Process
	End if 
Else 
	BEEP:C151
	uConfirm("Not Designer or Administrator, ehh?"; "Ohh"; "Well then")
End if 

