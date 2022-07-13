//(S) [CONTROL]SaleEvent'ibNew
If (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	ViewSetter(1; ->[Salesmen:32])
	
Else 
	BEEP:C151
	ALERT:C41("Only the SalesManager may enter a new salesman.")
End if 
//
//EOS