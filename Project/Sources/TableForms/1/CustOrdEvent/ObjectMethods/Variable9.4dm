If (User in group:C338(Current user:C182; "CustomerOrdering"))
	ViewSetter(2; ->[Customers_Orders:40])
Else 
	uNotAuthorized
End if 