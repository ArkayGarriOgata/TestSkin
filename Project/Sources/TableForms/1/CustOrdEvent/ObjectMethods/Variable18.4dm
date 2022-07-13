//Script: bClose()  053195  MLB
//•053195  MLB  UPR 187
If (User in group:C338(Current user:C182; "AccountsReceivable")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	C_LONGINT:C283($id)
	$id:=uSpawnProcess("Invoice_Management"; 0; "Invoicing")
	If (False:C215)
		Invoice_Management
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("You must be in the AccountsReceivable group to do Invoicing.")
End if 
//