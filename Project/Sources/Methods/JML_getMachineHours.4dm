//%attributes = {}
// ----------------------------------------------------
// Method: JML_getMachineHours(job_form;->M1;->M2) -> ttl_hours
// By: Mel Bohince @ 04/13/16, 10:18:52
// Description
// rtn total budgeted machine hours as M1 + M2, where M1 is pre-glue, M2 is gluing
// split this way so Johnson's Rule for scheduling 2 machines is possible
// ----------------------------------------------------
//future, find number of sheets, use new rate tables to establish hours

READ ONLY:C145([Job_Forms_Machines:43])
C_REAL:C285($M1; $M2; $total_process_hours; $printing)
C_LONGINT:C283($0)  //going to round at the end
C_TEXT:C284($1; $jobform)
C_POINTER:C301($2; $3; $4)

$jobform:=$1
$M1:=0  //process up to gluing
$M2:=0  //gluing
$printing:=0
$total_process_hours:=$M1+$M2

QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jobform)
If (Records in selection:C76([Job_Forms_Machines:43])>0)
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $aCC; [Job_Forms_Machines:43]Planned_MR_Hrs:15; $aMR; [Job_Forms_Machines:43]Planned_RunHrs:37; $aRun)
	
	C_LONGINT:C283($i; $numElements)
	$numElements:=Size of array:C274($aCC)
	uThermoInit($numElements; "Adding hours")
	For ($i; 1; $numElements)
		If (Position:C15($aCC{$i}; <>GLUERS)=0)  //not a gluer
			$M1:=$M1+($aMR{$i}+$aRun{$i})
			
			If (Position:C15($aCC{$i}; <>PRESSES)>0)
				$printing:=$printing+($aMR{$i}+$aRun{$i})
			End if 
			
		Else 
			$M2:=$M2+($aMR{$i}+$aRun{$i})
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
	$total_process_hours:=$M1+$M2
	
	REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
End if 


$2->:=Round:C94($M1; 0)
$3->:=Round:C94($M2; 0)
$4->:=Round:C94($printing; 0)
$0:=Round:C94($total_process_hours; 0)




