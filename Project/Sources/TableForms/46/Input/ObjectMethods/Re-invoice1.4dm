If ([Customers_ReleaseSchedules:46]Actual_Qty:8>0) & ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)  //|(true)
	If (User in group:C338(Current user:C182; "RolePlanner"))
		SAVE RECORD:C53([Customers_ReleaseSchedules:46])
		$numberOfASNs:=EDI_AdvanceShipNotice([Customers_ReleaseSchedules:46]Actual_Date:7; [Customers_ReleaseSchedules:46]ReleaseNumber:1)
		If ($numberOfASNs>0)
			uConfirm("ASN saved to EDI outbox"; "Ok"; "Great!")
		Else 
			uConfirm("No ASN created, verify ship-to"; "Hmmm"; "What!")
		End if 
		ACCEPT:C269
		
	Else 
		uConfirm("Log in as a Planner to generate ASN."; "OK"; "Help")
	End if 
	
Else 
	uConfirm("Can't generate ASN until shipped."; "OK"; "Help")
End if 