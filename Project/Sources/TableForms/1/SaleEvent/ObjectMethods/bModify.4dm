// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/07/13, 11:59:41
// ----------------------------------------------------
// Method: [zz_control].SaleEvent.bModify
// ----------------------------------------------------

If (User in group:C338(Current user:C182; "SalesReps")) | (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	ViewSetter(2; ->[Salesmen:32])
Else 
	uNotAuthorized
End if 