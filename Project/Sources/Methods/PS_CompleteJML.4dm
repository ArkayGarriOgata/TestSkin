//%attributes = {"publishedWeb":true}
//PM: PS_CompleteJML() -> 
//@author mlb - 4/17/02  11:54
//set printing complete it no other press sequences scheduled
//• mlb - 6/18/02  10:43 two stage complete
// Modified by: MelvinBohince (1/21/22) set numRecs:=0 
//--------------------------------------
// Modified by: MelvinBohince (2/3/22)  r-o Jml at the end

C_POINTER:C301($1; $datePtr)
C_DATE:C307($dateCompleted)

If (Count parameters:C259=0)
	$datePtr:=->[Job_Forms_Master_Schedule:67]Printed:32
Else 
	$datePtr:=$1
End if 


Case of 
	: (Count parameters:C259=0)
		$datePtr:=->[Job_Forms_Master_Schedule:67]Printed:32
		$dateCompleted:=TS2Date([ProductionSchedules:110]Completed:23)  //• mlb - 6/18/02  10:43 two stage complete
		
	: (Count parameters:C259<2)
		$datePtr:=$1
		$dateCompleted:=TS2Date([ProductionSchedules:110]Completed:23)  //• mlb - 6/18/02  10:43 two stage complete
		
End case 


If (Position:C15([ProductionSchedules:110]CostCenter:1; <>PRESSES)>0)  //look for other press operations
	numRecs:=0  // Modified by: MelvinBohince (1/21/22) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; numRecs)
	$jf:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)+"@"
	PS_qryPrintingOnly("*"; "*")
	QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]JobSequence:8=$jf)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
Else   //(Position([ProductionSchedule]CostCenter;◊SHEETERS+◊STAMPERS+◊BLANKERS)>0)
	numRecs:=1
End if 

If (numRecs=1)
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=(Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)))
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1) & (fLockNLoad(->[Job_Forms_Master_Schedule:67]))
		If ($datePtr->=!00-00-00!)
			$datePtr->:=$dateCompleted
			SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		Else 
			
		End if 
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		
	Else 
		BEEP:C151
		zwStatusMsg("ERROR"; "Completed date could not be set on JobMasterLog")
	End if 
	READ ONLY:C145([Job_Forms_Master_Schedule:67])  // Modified by: MelvinBohince (2/3/22) 
End if 