//OM: bLoad() -> 
//@author mlb - 12/4/01  14:09
//If (Length(sCriterion1)=0)
//sCriterion1:=Request("Load for which press number?";"";"Load";"Cancel")
//End if 

//If (Length(sCriterion1)=3)
If (Records in selection:C76([ProductionSchedules:110])>0)
	LAST RECORD:C200([ProductionSchedules:110])
	$lastPriority:=[ProductionSchedules:110]Priority:3+100
Else 
	$lastPriority:=100
End if 
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
$numJML:=Records in selection:C76([Job_Forms_Master_Schedule:67])
ORDER BY:C49([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]PressDate:25; >)
$count:=0
uThermoInit($numJML; "Looking for new job sequences")
For ($i; 1; $numJML)
	uThermoUpdate($i; 1)
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]CostCenterID:4="412"; *)
	QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="415"; *)
	QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="416"; *)
	QUERY:C277([Job_Forms_Machines:43];  | ; [Job_Forms_Machines:43]CostCenterID:4="417"; *)
	QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
	
	ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
	For ($j; 1; Records in selection:C76([Job_Forms_Machines:43]))
		$jobSeq:=[Job_Forms_Machines:43]JobForm:1+"."+String:C10([Job_Forms_Machines:43]Sequence:5; "000")
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$jobSeq)
		If (Records in selection:C76([ProductionSchedules:110])=0)  //not already there
			$count:=$count+1
			CREATE RECORD:C68([ProductionSchedules:110])
			[ProductionSchedules:110]JobSequence:8:=$jobSeq
			[ProductionSchedules:110]Line:10:=[Job_Forms_Master_Schedule:67]Line:5
			[ProductionSchedules:110]Customer:11:=[Job_Forms_Master_Schedule:67]Customer:2
			[ProductionSchedules:110]CostCenter:1:=[Job_Forms_Machines:43]CostCenterID:4
			QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[ProductionSchedules:110]CostCenter:1)
			[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
			[ProductionSchedules:110]Priority:3:=$lastPriority
			$lastPriority:=$lastPriority+10
			[ProductionSchedules:110]StartDate:4:=[Job_Forms_Master_Schedule:67]PressDate:25
			[ProductionSchedules:110]StartTime:5:=?00:00:00?
			$hrs:=0
			If ([Job_Forms_Machines:43]Planned_RunHrs:37>0)
				$hrs:=$hrs+[Job_Forms_Machines:43]Planned_RunHrs:37
			End if 
			If ([Job_Forms_Machines:43]Planned_MR_Hrs:15>0)
				$hrs:=$hrs+[Job_Forms_Machines:43]Planned_MR_Hrs:15
			End if 
			
			[ProductionSchedules:110]DurationSeconds:9:=Time:C179(Time string:C180(($hrs*3600)))
			$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
			$duration:=[ProductionSchedules:110]DurationSeconds:9*1
			$end:=$start+$duration
			TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
			
			PS_setJobInfo([ProductionSchedules:110]JobSequence:8)
			
			SAVE RECORD:C53([ProductionSchedules:110])
		End if 
		NEXT RECORD:C51([Job_Forms_Machines:43])
	End for 
	NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
End for 
uThermoClose

QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1)
If (Records in selection:C76([ProductionSchedules:110])>0)
	pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
	ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
Else 
	pressBackLog:=0
End if 
BEEP:C151
zwStatusMsg("LOAD"; String:C10($count)+" job sequences have been appended to the schedule.")

//Else 
//BEEP
//ALERT("Press not specified")
//End if 