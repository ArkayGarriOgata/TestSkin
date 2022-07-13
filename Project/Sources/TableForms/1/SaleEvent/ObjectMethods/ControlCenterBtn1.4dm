//(S) [CONTROL]SaleEvent'ibMod
If (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	ViewSetter(2; ->[Salesmen:32])
Else 
	uNotAuthorized
End if 
//EOS