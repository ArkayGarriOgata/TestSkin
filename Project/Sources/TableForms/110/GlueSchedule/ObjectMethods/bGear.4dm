
// Method: [ProductionSchedules].GlueSchedule.bGear ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/25/14, 10:37:54
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
windowTitle:="Glue Schedule Settings"
$winRef:=OpenFormWindow(->[ProductionSchedules:110]; "GlueScheduleSettings"; ->windowTitle; windowTitle; 33)
DIALOG:C40([ProductionSchedules:110]; "GlueScheduleSettings")
CLOSE WINDOW:C154
If (ok=1)
	numRecs:=PSG_ApplySettingOptions(psg_progress; psg_assignments; psg_timeing)  //numRecs displayed under listbox
	PSG_LocalArray("sort"; 1)  //by release date, hrd, jobit
	tSortOrder:="Sorted by 8,9,5;"
	tTimingText:="Progress: "+psg_progress+"; Assignments: "+psg_assignments+"; Timing: "+psg_timeing  //tTimingText displayed under listbox
	
	OBJECT SET ENABLED:C1123(bExtend; False:C215)  // only extend when only one gluer displayed
	If (Length:C16(psg_assignments)<5)
		//$ccID:=Num(psg_assignments)
		If (Position:C15(psg_assignments; <>Gluers)>0)  //If ($ccID>475) & ($ccID<486)// Modified by: Mel Bohince (6/24/19) 
			OBJECT SET ENABLED:C1123(bExtend; True:C214)
		End if 
	End if 
End if 
REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)

