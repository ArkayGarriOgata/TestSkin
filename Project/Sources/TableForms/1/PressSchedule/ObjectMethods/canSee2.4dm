If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	If (sCriterion1=[ProductionSchedules:110]CostCenter:1)
		uConfirm("Lift this job sequence to be resumed at a later date?"; "Lift"; "Cancel")
		If (ok=1)
			app_Log_Usage("log"; "PS Lift"; [ProductionSchedules:110]JobSequence:8)
			PS_updateRecord(->[ProductionSchedules:110]Priority:3; [ProductionSchedules:110]Priority:3*-1)
		End if 
		
	Else   //select
		uConfirm("Please select the job sequence to Lift."; "OK"; "Help")
	End if 
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 