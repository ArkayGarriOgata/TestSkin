// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 06/10/13, 14:51:09
// ----------------------------------------------------
// Method: [zz_control].PressSchedule.cbFilter
// Description:
// Filters the listing to show only jobs for the next
//  two weeks that haven't been released.
// ----------------------------------------------------
// Modified by: Mel Bohince (6/20/13) avoid PS_qryCurrentBackLog when filter is set

If (Self:C308->=1)
	app_Log_Usage("log"; "PS Next3"; "")
	PSFilterReleased(1)
	If (Records in selection:C76([ProductionSchedules:110])>0)
		pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600  //this is a two week unreleased backlog
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
	Else 
		pressBackLog:=0
	End if 
	bNeedPlated:=0
	
Else 
	PSFilterReleased(0)
	pressBackLog:=PS_qryCurrentBackLog(sCriterion1)  // Modified by: Mel Bohince (6/20/13)restore full backlog
End if 

