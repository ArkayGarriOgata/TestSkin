//(S) [CONTROL]SaleEvent'ibMod
If (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	Sales_ControlCenter
Else 
	uNotAuthorized
End if 
//EOS