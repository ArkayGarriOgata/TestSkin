If ([Customers_ReleaseSchedules:46]Actual_Qty:8>0) & ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)
	If (User in group:C338(Current user:C182; "RoleAccounting"))  //(Current user="Designer")
		[Customers_ReleaseSchedules:46]InvoiceNumber:9:=REL_ReleaseShipped(0; [Customers_ReleaseSchedules:46]Actual_Date:7+1; [Customers_ReleaseSchedules:46]ReleaseNumber:1; <>zResp; [Customers_ReleaseSchedules:46]B_O_L_number:17)
		
	Else 
		uConfirm("Log in as Designer to (re)invoice."; "OK"; "Help")
	End if 
	
Else 
	uConfirm("Can't Invoice until shipped."; "OK"; "Help")
End if 