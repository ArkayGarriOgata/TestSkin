//%attributes = {"publishedWeb":true}
//PM: JML_getOperations() -> 
//@author mlb - 7/30/02  15:22
// • mel (3/3/04, 10:32:53)`restore read write state

C_TEXT:C284($routing)
C_LONGINT:C283($i)
C_BOOLEAN:C305($wasReadOnly)

//If (Length([Job_Forms_Master_Schedule]Operations)=0)
//If (Position("**";[Job_Forms_Master_Schedule]JobForm)=0)
CUT NAMED SELECTION:C334([Job_Forms_Machines:43]; "holdOps")
$wasReadOnly:=Read only state:C362([Job_Forms_Machines:43])  // • mel (3/3/04, 10:32:53)`restore read write state

READ ONLY:C145([Job_Forms_Machines:43])
QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Job_Forms_Master_Schedule:67]JobForm:4)
If (Records in selection:C76([Job_Forms_Machines:43])>0)
	SELECTION TO ARRAY:C260([Job_Forms_Machines:43]CostCenterID:4; $aCC; [Job_Forms_Machines:43]Sequence:5; $aSeq; [Job_Forms_Machines:43]Actual_Qty:19; $aQty)
	SORT ARRAY:C229($aSeq; $aCC; $aQty; >)
	$routing:=""
	For ($i; 1; Size of array:C274($aSeq))
		If ($aQty{$i}=0)
			$routing:=$routing+$aCC{$i}+" "
		Else 
			$routing:=$routing+$aCC{$i}+"*"
		End if 
	End for 
	[Job_Forms_Master_Schedule:67]Operations:36:=$routing
End if 
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
If (Not:C34($wasReadOnly))  // • mel (3/3/04, 10:32:53)`restore read write state
	
	READ WRITE:C146([Job_Forms_Machines:43])
End if 
USE NAMED SELECTION:C332("holdOps")
//End if 
//End if 