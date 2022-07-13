//(S) [RAW_MATERIALS]POArray'bRemove
//• 2/13/97 cs onsite allow user to change locaton without changing copmany

If (aRMPONum>0)
	$rcn:=String:C10(aRMRecNo{aRMPONum})
	POI_ItemsToPost(aRMPONum; "Delete")
	uConfirm("RCN "+$rcn+" has been VOIDED."; "OK"; "Help")
	gSrchPONum
	
Else 
	uConfirm("You must first select an item from the 'Receipts to Post' section."; "OK"; "Help")
End if 