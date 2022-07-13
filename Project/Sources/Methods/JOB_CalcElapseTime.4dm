//%attributes = {}
// Method: JOB_CalcElapseTime (jobform{;"ACTUAL"}) -> 
// ----------------------------------------------------
// by: mel: 10/03/03, 12:05:53
// ----------------------------------------------------
// Description:
// returns budgeted or actual time of operations as the Sum of MR&Run
// ----------------------------------------------------

C_TEXT:C284($1; $2)
C_REAL:C285($0; $hrs)

READ ONLY:C145([Job_Forms_Machines:43])
READ ONLY:C145([Job_Forms_Machine_Tickets:61])

$hrs:=0

If (Count parameters:C259=1)
	QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$1)
	If (Records in selection:C76([Job_Forms_Machines:43])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Machines:43]Planned_MR_Hrs:15; $aMR; [Job_Forms_Machines:43]Planned_RunHrs:37; $aRun)
		For ($i; 1; Size of array:C274($aMR))
			$hrs:=$hrs+$aMR{$i}+$aRun{$i}
		End for 
	End if 
	
Else 
	QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]JobForm:1=$1)
	If (Records in selection:C76([Job_Forms_Machine_Tickets:61])>0)
		SELECTION TO ARRAY:C260([Job_Forms_Machine_Tickets:61]MR_Act:6; $aMR; [Job_Forms_Machine_Tickets:61]Run_Act:7; $aRun)
		For ($i; 1; Size of array:C274($aMR))
			$hrs:=$hrs+$aMR{$i}+$aRun{$i}
		End for 
	End if 
End if 

$0:=$hrs