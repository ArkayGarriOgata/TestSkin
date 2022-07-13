//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/17/06, 14:11:42
// ----------------------------------------------------
// Method: RM_ReverseIssue
// ----------------------------------------------------

$winRef:=Open form window:C675([Raw_Materials:21]; "RM_ReverseIssue_dio")
SET MENU BAR:C67(4)
READ WRITE:C146([Raw_Materials_Locations:25])

DIALOG:C40([Raw_Materials:21]; "RM_ReverseIssue_dio")
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([Raw_Materials_Locations:25])
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
	
	
Else 
	
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
	
	
End if   // END 4D Professional Services : January 2019 
CLOSE WINDOW:C154
uWinListCleanup