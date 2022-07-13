//%attributes = {"publishedWeb":true}
//PS_getMRhours

C_TIME:C306($0; $mrHrs)

$mrHrs:=?00:00:00?
//READ ONLY([ProdSchdMakeReady])
//QUERY([ProdSchdMakeReady];[ProdSchdMakeReady]JobSequence=[ProductionSchedule]Job
//If (Records in selection([ProdSchdMakeReady])=1)
$mrHrs:=[ProductionSchedules:110]MRtarget:31
OK:=1

If ($mrHrs=?00:00:00?)
	READ ONLY:C145([Job_Forms_Machines:43])
	$jf:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
	$seq:=Num:C11(Substring:C12([ProductionSchedules:110]JobSequence:8; 10))
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobSequence:8=[ProductionSchedules:110]JobSequence:8)  //$jf;*)
	//QUERY([Job_Forms_Machines]; & [Job_Forms_Machines]Sequence=$seq)
	If (Records in selection:C76([Job_Forms_Machines:43])>0)
		$mrHrs:=Time:C179(Time string:C180(([Job_Forms_Machines:43]Planned_MR_Hrs:15*3600)))
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		uConfirm("Use "+String:C10($mrHrs; HH MM SS:K7:1)+" from sequence "+[ProductionSchedules:110]JobSequence:8; "Yes"; "No")
	Else 
		BEEP:C151
		$mrHrs:=?01:01:01?
		$mrHrs:=Time:C179(Request:C163("Enter the time limit:"; String:C10($mrHrs; HH MM SS:K7:1); "Set"; "Cancel"))
	End if 
End if 

If (OK=1)
	$0:=$mrHrs
Else 
	$0:=?00:00:00?
End if 