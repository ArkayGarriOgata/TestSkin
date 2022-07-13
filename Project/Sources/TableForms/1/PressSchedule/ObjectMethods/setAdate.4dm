//(S) [ReleaseSchedule]'List'bPriority
If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	app_Log_Usage("log"; "PS Date"; sCriterion1)
	JML_SetDate(Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8); Num:C11(Substring:C12([ProductionSchedules:110]JobSequence:8; 10; 3)))
	zwStatusMsg("REMINDER"; "Choose Update Job Info under the Press menu to see recently entered dates.")
	
	PS_setPageBasedOnAccess
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 
