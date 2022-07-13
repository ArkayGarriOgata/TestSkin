//(S) [CONTROL]VendorEvent'ibMod
If (Not:C34(User in group:C338(Current user:C182; "Purchasing"))) & (Not:C34(User in group:C338(Current user:C182; "Requisitioning")))
	uNotAuthorized
Else 
	ViewSetter(2; ->[Vendors:7])
End if 
//EOS