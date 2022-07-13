//(S) [RAW_MATERIALS]FormArray'bCancel
If (Size of array:C274(aRMJFNum)#0)
	BEEP:C151
	uConfirm("You have left "+String:C10(Size of array:C274(aRMJFNum))+" item(s) unposted!"+<>sCR+"Return to Post Screen?"; "Go back"; "Ignor them")
	If (OK=0)
		CANCEL:C270
		bCancel:=1
	End if 
	
Else 
	CANCEL:C270
	bCancel:=1
End if 
//EOS