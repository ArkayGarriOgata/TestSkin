//bGantt 12/13/01 Systems G4
If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	<>jobform:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
	If (Length:C16(<>jobform)=8)
		PS_showScheduleForJob(<>jobform)
	End if 
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 