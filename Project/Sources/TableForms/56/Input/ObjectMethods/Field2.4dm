If ([Process_Specs_Materials:56]CostCtrID:3#"")
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Process_Specs_Materials:56]CostCtrID:3)
	If (Records in selection:C76([Cost_Centers:27])=0)
		ALERT:C41("Warning: That Cost Center ID does not exist.  Enter a valid Cost Center.")
	End if 
End if 