//%attributes = {"publishedWeb":true}
//PM: JML_PressScheduleTimerMR() -> 
//@author mlb - 4/9/02  11:53

If (Records in set:C195("clickedIncludeRecord")=1)
	CUT NAMED SELECTION:C334([ProductionSchedules:110]; "hold_sequences")
	USE SET:C118("clickedIncludeRecord")
	$jf:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
	$seq:=Num:C11(Substring:C12([ProductionSchedules:110]JobSequence:8; 10))
	
	READ ONLY:C145([Job_Forms_Machines:43])
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jf; *)
	QUERY:C277([Job_Forms_Machines:43];  & [Job_Forms_Machines:43]Sequence:5=$seq)
	If (Records in selection:C76([Job_Forms_Machines:43])>0)
		$mrHrs:=Time:C179(Time string:C180(([Job_Forms_Machines:43]Planned_MR_Hrs:15*3600)))
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		//$mrHrs:=Time(Time string((0.05*3600)))
		zwStatusMsg("MAKE READY"; "  MR= "+String:C10($mrHrs; HH MM SS:K7:1)+" Timer started at "+String:C10(Current time:C178; HH MM SS:K7:1))
		$pid:=New process:C317("util_countDownTimer"; <>lMinMemPart; "$Timer"; [ProductionSchedules:110]CostCenter:1+": "+[ProductionSchedules:110]JobSequence:8+" Make Ready Remaining"; Current time:C178+$mrHrs)
		
	Else 
		BEEP:C151
		ALERT:C41($jf+"."+String:C10($seq; "00")+" was not found.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Select a job sequence")
	zwStatusMsg(""; "  ")
End if 

USE NAMED SELECTION:C332("hold_sequences")