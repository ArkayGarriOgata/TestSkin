//OM: bValidate() -> 
//@author mlb - 2/20/02  14:32
$reject:=False:C215

If (Length:C16(sCriterion1)#11)
	uConfirm("A job item is needed to continue."; "Try Again"; "Help")
	$reject:=True:C214
End if 

If (Num:C11(sCriterion2)<=0)
	//If (Position("Proct";sCustName)>0)
	uConfirm("A quantity is needed to continue."; "Try Again"; "Help")
	$reject:=True:C214
	//End if 
End if 

If (Num:C11(sCriterion4)<=0)
	uConfirm("You must enter at least one pallet to continue. "; "Try Again"; "Help")
	$reject:=True:C214
End if 

If (Num:C11(sCriterion5)<=0)
	uConfirm("You must enter at least one label per pallet to continue.  "; "Try Again"; "Help")
	$reject:=True:C214
End if 

If (cbSuperCase=1) & (Length:C16(wms_bin_id)=0)
	uConfirm("You must enter a WMS bin id.  "; "Try Again"; "Help")
	$reject:=True:C214
End if 

If (cbReceiveAMS=1) & (wms_bin_id#"BNRCC")
	uConfirm("Receipts must go to WMS bin id = BNRCC."; "Try Again"; "Help")
	$reject:=True:C214
End if 

If ($reject)
	REJECT:C38
End if 