Pjt_setReferId(pjtId)
READ WRITE:C146([Customers_Orders:40])
QUERY:C277([Customers_Orders:40])
If (ok=1)
	If (Pjt_AddToProjectLimitor(->[Customers_Orders:40]))
		uConfirm("Change "+String:C10(Records in selection:C76([Customers_Orders:40]))+" records to project number "+pjtId+"?")
		If (ok=1)
			APPLY TO SELECTION:C70([Customers_Orders:40]; ORD_AssignToProject(pjtId))
		End if 
		
	End if 
End if 
