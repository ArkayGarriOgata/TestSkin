//(S) bCancel: 

If (Size of array:C274(adMADate)>0) | (iMASeq#0)
	uConfirm("Cancel all Machine Ticket entries just entered?"; "Yes"; "Go Back")
	If (OK=1)
		CANCEL:C270
	Else 
		REJECT:C38
	End if 
Else 
	CANCEL:C270
End if 