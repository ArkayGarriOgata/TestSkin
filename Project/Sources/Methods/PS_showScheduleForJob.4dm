//%attributes = {}
// Method: PS_showScheduleForJob (job form) -> 
// ----------------------------------------------------
// by: mel: 06/14/04, 15:05:36
// ----------------------------------------------------
// Description:
// list all the scheduled operations for  a job (in a new process)
// ----------------------------------------------------

C_LONGINT:C283($pid)
C_TEXT:C284($1; $2)

If (Count parameters:C259=1)
	$pid:=New process:C317("PS_showScheduleForJob"; <>lMinMemPart; "Show Job's Schedule"; $1; "show")
	
Else 
	If (Length:C16($1)=8)
		READ ONLY:C145([ProductionSchedules:110])
		//v1.0.0-PJK (12/22/15)  QUERY([ProductionSchedules];[ProductionSchedules]JobSequence=($1+"@"))
		//v1.0.0-PJK (12/22/15) the search for [ProductionSchedules] has been moved to inside PS_Gantt
		PS_Gantt($1)  //v1.0.0-PJK (12/21/15) pass the job form ID
		
	Else 
		uConfirm("Select the job that you want to see the schedule for."; "OK"; "Help")
	End if 
End if 