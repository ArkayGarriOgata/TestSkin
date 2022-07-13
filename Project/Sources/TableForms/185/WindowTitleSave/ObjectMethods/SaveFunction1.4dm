// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/06/12, 12:00:41
// ----------------------------------------------------
// Method: [WindowSets].WindowTitleSave.SaveFunction1
// Description:
// Removed a Window Set and the records that go with it.
// ----------------------------------------------------

C_LONGINT:C283($xlPosition)

$xlPosition:=Find in array:C230(bWindowNames; True:C214)
$tName:=atWindowSets{$xlPosition}
CONFIRM:C162("Remove "+util_Quote($tName)+" from the Window Sets?")

If (OK=1)
	QUERY:C277([WindowSetTitles:186]; [WindowSetTitles:186]pk_id:1=asUUID{$xlPosition})  // Modified by: Mark Zinke (5/31/13)
	QUERY:C277([WindowSets:185]; [WindowSets:185]ID:1=[WindowSetTitles:186]ID:4)  // Modified by: Mark Zinke (5/31/13)
	DELETE SELECTION:C66([WindowSetTitles:186])
	DELETE SELECTION:C66([WindowSets:185])
	LISTBOX DELETE ROWS:C914(bWindowNames; $xlPosition)
	OBJECT SET ENABLED:C1123(bOK; False:C215)
End if 