// ----------------------------------------------------
// User name (OS): mBohince
// Date: 031297
// ----------------------------------------------------
// Object Method: [Finished_Goods].AskMe.Variable1
// ----------------------------------------------------

xText:=""
$hold_window_title:=Get window title:C450

READ WRITE:C146([Finished_Goods:26])
LOAD RECORD:C52([Finished_Goods:26])

If (fLockNLoad(->[Finished_Goods:26]))
	$winRef:=OpenSheetWindow(->[zz_control:1]; "FGNotesDisplay"; "Internal Ask Me Notes for "+[Finished_Goods:26]ProductCode:1)
	FORM SET INPUT:C55([zz_control:1]; "FGNotesDisplay")
	ADD RECORD:C56([zz_control:1]; *)
	FORM SET INPUT:C55([zz_control:1]; "Input")
	
	If (bFgNotes=1) & (xText#"")
		SetObjectProperties(""; ->bFgNotes; True:C214; "View Notes")  // Modified by: Mark Zinke (5/15/13)
	Else 
		SetObjectProperties(""; ->bFgNotes; True:C214; "New Note")  // Modified by: Mark Zinke (5/15/13)
	End if 
	
	CLOSE WINDOW:C154
	READ ONLY:C145([Finished_Goods:26])
	UNLOAD RECORD:C212([Finished_Goods:26])
	xText:=""
	
End if 

SET WINDOW TITLE:C213($hold_window_title)