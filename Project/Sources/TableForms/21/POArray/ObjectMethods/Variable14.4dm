//(S) [RAW_MATERIALS]POArray'bCancel

startFresh:=True:C214
$pendingReceipts:=Size of array:C274(aRMPONum)

If ($pendingReceipts#0)
	uConfirm("Ignor the items that are ready to Post?"; "Go Back"; "Ignor")
	If (OK=1)
		REJECT:C38
		startFresh:=False:C215
	End if 
End if 