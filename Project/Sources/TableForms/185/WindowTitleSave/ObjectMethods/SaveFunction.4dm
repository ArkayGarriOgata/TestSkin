// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/06/12, 11:34:17
// ----------------------------------------------------
// Method: [WindowSets].WindowTitleSave.Picture Button1
// Description:
// Adds a window set
// ----------------------------------------------------

C_TEXT:C284(<>tWindowSetName)
C_LONGINT:C283($xlPosition)

<>tWindowSetName:=Request:C163("Enter the Window Set name")

If (OK=1)
	LISTBOX INSERT ROWS:C913(bWindowNames; 1)
	atWindowSets{1}:=<>tWindowSetName
	LISTBOX SORT COLUMNS:C916(bWindowNames; 2; >)
	$xlPosition:=Find in array:C230(atWindowSets; <>tWindowSetName)
	LISTBOX SELECT ROW:C912(bWindowNames; $xlPosition; lk replace selection:K53:1)
	OBJECT SET ENABLED:C1123(bOK; True:C214)
End if 