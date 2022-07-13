//%attributes = {"publishedWeb":true}
//PM: PS_Save() -> 
//@author mlb - 6/18/02  12:14

CUT NAMED SELECTION:C334([ProductionSchedules:110]; "whileSaving")
ALL RECORDS:C47([ProductionSchedules:110])
$numRecs:=Records in selection:C76([ProductionSchedules:110])

zwStatusMsg("SAVE"; "Assign a name to your saved schedule.")
SET CHANNEL:C77(12; "")
If (ok=1)
	uThermoInit($numRecs; "Exporting to "+document)
	For ($i; 1; $numRecs)
		SEND RECORD:C78([ProductionSchedules:110])
		NEXT RECORD:C51([ProductionSchedules:110])
		uThermoUpdate($i)
	End for 
	uThermoClose
End if 
SET CHANNEL:C77(11)
zwStatusMsg("SAVE"; "Click Recall, and select "+document+" to restore schedule to this state.")
USE NAMED SELECTION:C332("whileSaving")
//
If (Application type:C494=4D Remote mode:K5:5) | (Current user:C182="Designer")
	QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
	$numRecs:=Records in selection:C76([Job_Forms_Master_Schedule:67])
	If ($numRecs>0)
		util_deleteDocument("jml.records")
		SET CHANNEL:C77(12; "jml.records")
		If (ok=1)
			uThermoInit($numRecs; "Exporting to "+document)
			For ($i; 1; $numRecs)
				SEND RECORD:C78([Job_Forms_Master_Schedule:67])
				NEXT RECORD:C51([Job_Forms_Master_Schedule:67])
				uThermoUpdate($i)
			End for 
			uThermoClose
		End if 
		SET CHANNEL:C77(11)
	End if 
End if 