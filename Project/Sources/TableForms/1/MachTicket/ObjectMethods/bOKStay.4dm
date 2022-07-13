If (sMAJob#"")
	uConfirm("'Move >>>' or 'Clear' your last entry before Saving."; "OK"; "Help")
Else 
	If (Size of array:C274(adMADate)>0)
		mMachTickDo
		OBJECT SET ENABLED:C1123(bOK; False:C215)
		OBJECT SET ENABLED:C1123(bOKStay; False:C215)
	End if 
End if 