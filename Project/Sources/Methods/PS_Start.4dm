//%attributes = {}
// -------
// Method: PS_Start   ( ) ->
// By: Mel Bohince @ 02/21/18, 13:53:52
// Description
// 
// ----------------------------------------------------

// -------
// Method: [zz_control].PressSchedule.canSeeStart   ( ) ->
// By: Mel Bohince @ 02/21/18, 13:53:52
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (3/1/18) add some feedback
// Modified by: Mel Bohince (4/9/18) save via PS_updateRecord to get record in readwrite

app_Log_Usage("log"; "PS Started"; [ProductionSchedules:110]JobSequence:8)

If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	
	If (sCriterion1=[ProductionSchedules:110]CostCenter:1)
		$continue:=True:C214
		If ([ProductionSchedules:110]StartedAt_ts:79#0)
			uConfirm("Already started at "+TS2String([ProductionSchedules:110]StartedAt_ts:79)+". Reset?"; "Reset"; "Cancel")
			If (ok=1)
				PS_updateRecord(->[ProductionSchedules:110]StartedAt_ts:79; 0)
			End if 
			
		Else 
			uConfirm("Starting job sequence "+[ProductionSchedules:110]JobSequence:8+"?"; "Starting"; "Cancel")
			If (ok=1)
				PS_updateRecord(->[ProductionSchedules:110]StartedAt_ts:79; TSTimeStamp)
				PF_SendStartTask([ProductionSchedules:110]JobSequence:8; sCriterion1; 0)
			End if 
		End if 
	End if 
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 

