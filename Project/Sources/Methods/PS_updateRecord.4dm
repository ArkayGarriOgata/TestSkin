//%attributes = {"publishedWeb":true}
//PM: PS_updateRecord(field;value) -> 
//@author mlb - 6/25/02  16:44
//make a change while in readOnly state

C_POINTER:C301($1)
C_REAL:C285($2)

$preState:=util_getReadWriteState(->[ProductionSchedules:110])
READ WRITE:C146([ProductionSchedules:110])
LOAD RECORD:C52([ProductionSchedules:110])
//$preState2:=util_getReadWriteState (->[ProductionSchedule])
If (fLockNLoad(->[ProductionSchedules:110]))
	$1->:=$2
	Case of 
		: ($2>0)
			[ProductionSchedules:110]AllOperations:14:="Done: "+TS2String($2)
		: ($2=0)
			$jobform:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
			If ([Job_Forms_Master_Schedule:67]JobForm:4#($jobform))
				$queriedJML:=True:C214
				READ ONLY:C145([Job_Forms_Master_Schedule:67])
				QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$jobform)
			Else 
				$queriedJML:=False:C215
			End if 
			[ProductionSchedules:110]AllOperations:14:=[Job_Forms_Master_Schedule:67]Operations:36
			If ($queriedJML)
				REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
			End if 
	End case 
	
	SAVE RECORD:C53([ProductionSchedules:110])
End if 
//restore read only
If ($preState)
	READ ONLY:C145([ProductionSchedules:110])
	LOAD RECORD:C52([ProductionSchedules:110])
End if 
//$preState2:=util_getReadWriteState (->[ProductionSchedule])
If ($1->#$2)
	BEEP:C151
	ALERT:C41("Update failed, try again soon.")
End if 