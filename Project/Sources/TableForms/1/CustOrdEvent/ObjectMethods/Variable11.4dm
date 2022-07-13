//(S) [CONTROL]POEvent'ibOther
If (User in group:C338(Current user:C182; "CustomerOrdering"))
	//uSpawnProcess ("gOrdertoApp";48000;"Change Order Managmnt";True;False)
	ViewSetter(2; ->[Customers_Order_Change_Orders:34])
Else 
	uNotAuthorized
End if 
//EOS