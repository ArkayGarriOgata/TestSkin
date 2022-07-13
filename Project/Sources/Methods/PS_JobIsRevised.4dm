//%attributes = {}
// Method: PS_JobIsRevised () -> 
// ----------------------------------------------------
// by: mel: 05/13/04, 16:11:49
// ----------------------------------------------------
// Modified by: Mel Bohince (3/29/18) add custname incase this was a merged customer job

C_LONGINT:C283($i; $numRecs)
C_TEXT:C284($1; $2; $custName)
$custName:=$2
QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$1)
$numRecs:=Records in selection:C76([Job_Forms_Machines:43])
For ($i; 1; $numRecs)
	PS_RevisionLog([Job_Forms_Machines:43]JobSequence:8; $custName)  //;[Job_Forms_Machines]Sequence;[Job_Forms_Machines]CostCenterID;[Job_Forms_Machines]Planned_RunHrs;[Job_Forms_Machines]Planned_MR_Hrs)  `• mlb - 6/18/02  15:41
	NEXT RECORD:C51([Job_Forms_Machines:43])
End for 