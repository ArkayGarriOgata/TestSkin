
uConfirm("Test AV SQL connection?"; "Yes"; "No")
If (ok=1)
	//av_accounts_receivable ("request")
	av_accounts_receivable_v2("test")
	
Else 
	BEEP:C151
End if 

