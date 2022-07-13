//%attributes = {"publishedWeb":true}
//PM: PS_Recall() -> 
//@author mlb -
//• mlb - 6/18/02  12:13 make aware of completed sequences
// Modified by: MelvinBohince (1/21/22) remove call to init the JML_cache

C_LONGINT:C283($locked; $numRecs)

CUT NAMED SELECTION:C334([ProductionSchedules:110]; "recovery")
READ WRITE:C146([ProductionSchedules:110])
util_deleteDocument("LastPressSchedule.bku")
ALL RECORDS:C47([ProductionSchedules:110])
$numRecs:=Records in selection:C76([ProductionSchedules:110])
SET CHANNEL:C77(12; "LastPressSchedule")
If (OK=1)
	uThermoInit($numRecs; "Backing up to "+document)
	For ($i; 1; $numRecs)
		SEND RECORD:C78([ProductionSchedules:110])
		NEXT RECORD:C51([ProductionSchedules:110])
		uThermoUpdate($i)
	End for 
	uThermoClose
	SET CHANNEL:C77(11)
	
	SET CHANNEL:C77(10; "")
	If (OK=1)
		//remember those that have been marked as completed    
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23#0)  //• mlb - 6/18/02  12:12
		SELECTION TO ARRAY:C260([ProductionSchedules:110]JobSequence:8; $aJobSeq; [ProductionSchedules:110]Completed:23; $aCompleted)
		START TRANSACTION:C239
		ALL RECORDS:C47([ProductionSchedules:110])
		DELETE SELECTION:C66([ProductionSchedules:110])
		ALL RECORDS:C47([ProductionSchedules:110])
		$locked:=Records in selection:C76([ProductionSchedules:110])
		If ($locked=0)
			VALIDATE TRANSACTION:C240
		Else 
			CANCEL TRANSACTION:C241
		End if 
		
		If ($locked=0)
			$Doc:=Document
			RECEIVE RECORD:C79([ProductionSchedules:110])
			$i:=1
			While (OK=1)
				$hit:=Find in array:C230($aJobSeq; [ProductionSchedules:110]JobSequence:8)
				If ($hit>-1)
					[ProductionSchedules:110]Completed:23:=$aCompleted{$hit}
				End if 
				SAVE RECORD:C53([ProductionSchedules:110])
				$i:=$i+1
				RECEIVE RECORD:C79([ProductionSchedules:110])
			End while 
			zwStatusMsg("RECALL"; String:C10($i)+" records recalled from "+document)
			SET CHANNEL:C77(11)
			
			If (Application type:C494#4D Remote mode:K5:5)
				CONFIRM:C162("Load a 'jml.records' file?"; "Load"; "Skip")
				If (OK=1)
					SET CHANNEL:C77(10; "jml.records")
					If (ok=1)
						READ WRITE:C146([Job_Forms_Master_Schedule:67])
						ALL RECORDS:C47([Job_Forms_Master_Schedule:67])
						DELETE SELECTION:C66([Job_Forms_Master_Schedule:67])
						
						RECEIVE RECORD:C79([Job_Forms_Master_Schedule:67])
						$i:=1
						While (OK=1)
							SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
							$i:=$i+1
							RECEIVE RECORD:C79([Job_Forms_Master_Schedule:67])
						End while 
						SET CHANNEL:C77(11)
						//JML_cacheInfo ("init")// Removed by: MelvinBohince (1/21/22) 
					End if 
				End if 
			End if 
			
			PS_CallProcesses
			
		Else   //$locked
			USE NAMED SELECTION:C332("recovery")
			BEEP:C151
			ALERT:C41(String:C10($locked)+" records were in use, 'Recall' cannot be used at this time."; "Abort")
		End if   //$locked
		
	Else   //open file
		USE NAMED SELECTION:C332("recovery")
		BEEP:C151
		ALERT:C41("Recall aborted, no changes made. Recall file wasn't opened.")
	End if   //open file    
	
Else   //backup
	USE NAMED SELECTION:C332("recovery")
	BEEP:C151
	ALERT:C41("Recall aborted, no changes made. Couldn't make a backup.")
End if 