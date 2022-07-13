If ([Estimates_Materials:29]CostCtrID:2#"")
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Estimates_Materials:29]CostCtrID:2)
	If (Records in selection:C76([Cost_Centers:27])=0)
		uConfirm("Warning: That Cost Center ID does not exist.  Enter a valid Cost Center."; "OK"; "Help")
		[Estimates_Materials:29]CostCtrID:2:=""
	End if 
End if 