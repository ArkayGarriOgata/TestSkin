//Script: bClose()  053195  MLB
//•053195  MLB  UPR 187
If (User in group:C338(Current user:C182; "AccountsReceivable")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	INV_YTD_Billings_Export
	
Else 
	BEEP:C151
	ALERT:C41("You must be in the AccountsReceivable group to do Invoicing.")
End if 
//