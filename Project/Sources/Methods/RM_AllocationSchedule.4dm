//%attributes = {"publishedWeb":true}
//RM_AllocationSchedule(jobform;date to allocate)-> number changed
// OBSOLETE OBSOLETE OBSOLETEModified by: MelvinBohince (3/28/22) OBSOLETE date now set by batched RM_AllocationSetDate_eos called by Batch_RM_Allocations
C_TEXT:C284($form; $1)
C_LONGINT:C283($0; $numRMA)
C_DATE:C307($needed; $2)

$form:=$1
$needed:=$2
$numRMA:=0

If (Length:C16($form)>=5)
	READ WRITE:C146([Raw_Materials_Allocations:58])
	QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=$form)
	$numRMA:=Records in selection:C76([Raw_Materials_Allocations:58])
	Case of 
		: ($numRMA=1)
			[Raw_Materials_Allocations:58]Date_Allocated:5:=$needed
			SAVE RECORD:C53([Raw_Materials_Allocations:58])
		: ($numRMA>1)
			APPLY TO SELECTION:C70([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Date_Allocated:5:=$needed)
	End case 
	REDUCE SELECTION:C351([Raw_Materials_Allocations:58]; 0)
End if 

$0:=$numRMA
