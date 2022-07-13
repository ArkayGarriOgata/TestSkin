//%attributes = {}
// -------
// Method: PS_Show480   ( ) ->
// By: Mel Bohince @ 03/07/18, 16:32:46
// Description
// 
// ----------------------------------------------------

$gluer:=Request:C163("Gluer #: "; "480"; "Show"; "Cancel")
If (ok=1)
	PS_PressScheduleUI($gluer)
End if 