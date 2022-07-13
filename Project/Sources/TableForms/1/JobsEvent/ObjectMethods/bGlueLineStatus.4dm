
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/12/14, 10:34:49
// ----------------------------------------------------
// Method: [zz_control].JobsEvent.bGlueLineStatus
// Description
// 
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (2/12/20) change "All" to "AllGluers"

$press:=Request:C163("Start with which press?"; "AllGluers "+<>Gluers+" 9xx N/A"; "Show"; "Cancel")
If (ok=1)
	PSG_GlueScheduleUI($press)
End if 