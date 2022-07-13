//%attributes = {"publishedWeb":true}
//(P) gMTSaveNAccpt:

If (sMAJob#"")
	uConfirm("'Move >>>' or 'Clear' your last entry before Saving."; "OK"; "Help")
Else 
	If (Size of array:C274(adMADate)>0)
		ACCEPT:C269
	Else 
		CANCEL:C270
	End if 
End if 