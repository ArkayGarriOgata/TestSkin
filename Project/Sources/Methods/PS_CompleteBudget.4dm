//%attributes = {"publishedWeb":true}
//PM: JML_PressScheduleCompleteBudget() -> 
//@author mlb - 4/17/02  11:56
//• mlb - 6/18/02  10:43 two stage complete
// Modified by: Mel Bohince (6/10/16) use [Job_Forms_Machines]JobSequence
READ WRITE:C146([Job_Forms_Machines:43])

QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobSequence:8=[ProductionSchedules:110]JobSequence:8)
//$jf:=Substring([ProductionSchedules]JobSequence;1;8)
//$seq:=Num(Substring([ProductionSchedules]JobSequence;10))
//QUERY([Job_Forms_Machines];[Job_Forms_Machines]JobForm=$jf;*)
//QUERY([Job_Forms_Machines]; & ;[Job_Forms_Machines]Sequence=$seq)
If (Records in selection:C76([Job_Forms_Machines:43])>0)
	If (fLockNLoad(->[Job_Forms_Machines:43]))
		[Job_Forms_Machines:43]ScheduledBegin:28:=[ProductionSchedules:110]StartDate:4
		//[Job_Forms_Machines]ActualBegin:=[ProductionSchedules]StartDate
		[Job_Forms_Machines:43]ScheduleEnd:30:=[ProductionSchedules:110]EndDate:6
		[Job_Forms_Machines:43]ActualEnd:31:=TS2Date([ProductionSchedules:110]Completed:23)  //• mlb - 6/18/02  10:43 two stage complete
		SAVE RECORD:C53([Job_Forms_Machines:43])
	Else 
		BEEP:C151
	End if 
	REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
End if 