//%attributes = {"publishedWeb":true}
//PM: JML_setOperationDone(jobform;cc) -> 
//@author mlb - 7/30/02  15:25
// • mel (2/5/04, 09:28:30) don't hang on a lock

C_TEXT:C284($1)
C_TEXT:C284($2; $costCenter; $costCenterDone)

$costCenter:=$2+" "

If (Length:C16($costCenter)=4)
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1)
	If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
		If (Not:C34(Locked:C147([Job_Forms_Master_Schedule:67])))  //(fLockNLoad (->[JobMasterLog]))
			If (Position:C15($costCenter; [Job_Forms_Master_Schedule:67]Operations:36)>0)
				$costCenterDone:=$2+"*"
				[Job_Forms_Master_Schedule:67]Operations:36:=Replace string:C233([Job_Forms_Master_Schedule:67]Operations:36; $costCenter; $costCenterDone; 1)
				SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
			End if 
		End if 
		
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
	End if 
End if 