//(S) bChgRep
If (User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "RoleSuperUser"))
	uSpawnProcess("SpwnCustomerMov"; 0; "Move Customer"; True:C214; False:C215)
	If (False:C215)
		SpwnCustomerMov
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Only the SalesManager may reassign a customer to a different salesman.")
End if 
//