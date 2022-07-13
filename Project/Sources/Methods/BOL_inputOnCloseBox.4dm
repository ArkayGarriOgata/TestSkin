//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/17/07, 16:15:01
// ----------------------------------------------------
// Method: BOL_inputOnCloseBox()  --> 
// ----------------------------------------------------

If (iTotal>0)
	uConfirm("Ignor your prior picks?"; "Ignore"; "Go back")
	If (OK=1)
		CANCEL:C270
	End if 
	
Else 
	CANCEL:C270
End if 