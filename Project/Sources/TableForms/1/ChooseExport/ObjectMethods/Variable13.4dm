
If (sJobId="") & (sCustId="") & (sOrderId="") & (sEstimateId="")
	CONFIRM:C162("To Export an Item, You MUST Enter an ID Number for that Item."; "Try Again"; "Exit")
	
	If (OK=0)
		CANCEL:C270
	End if 
Else 
	ACCEPT:C269
End if 