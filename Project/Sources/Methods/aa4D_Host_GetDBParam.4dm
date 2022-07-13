//%attributes = {}
// Method name: aa4D_Host_GetDBParam (must be shared with components)
// Added by: Mel Bohince (6/24/19) 
C_LONGINT:C283($1)  // selector
C_REAL:C285($0)
$0:=-1  // Error, no parameter
If (Count parameters:C259>0)
	$0:=Get database parameter:C643($1)
End if 
