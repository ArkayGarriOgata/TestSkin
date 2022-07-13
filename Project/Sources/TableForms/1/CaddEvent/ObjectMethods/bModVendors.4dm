// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/06/13, 21:09:54
// ----------------------------------------------------
// Method: [zz_control].CaddEvent.bModVendors
// ----------------------------------------------------

If (Not:C34(User in group:C338(Current user:C182; "Purchasing"))) & (Not:C34(User in group:C338(Current user:C182; "Requisitioning")))
	uNotAuthorized
Else 
	ViewSetter(2; ->[Vendors:7])
End if 