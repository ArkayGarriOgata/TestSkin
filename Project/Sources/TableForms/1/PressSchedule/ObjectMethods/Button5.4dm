If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	<>jobform:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
	ToDo_UI
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 
