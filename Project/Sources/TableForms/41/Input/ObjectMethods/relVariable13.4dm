//how do you tell if a record is selected?

If (Records in set:C195("Customers_ReleaseSchedules")>0)
	CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "holdReleases")
	USE SET:C118("Customers_ReleaseSchedules")
	If ([Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		uConfirm("Are you sure you want to delete this record?"; "OK"; "Help")
		If (OK=1)
			DELETE RECORD:C58([Customers_ReleaseSchedules:46])
			
		End if 
	Else 
		uConfirm("Can't delete Releases that have shipped."; "OK"; "Help")
	End if 
	USE NAMED SELECTION:C332("holdReleases")
	
Else 
	uConfirm("Select a Release first."; "OK"; "Help")
End if 