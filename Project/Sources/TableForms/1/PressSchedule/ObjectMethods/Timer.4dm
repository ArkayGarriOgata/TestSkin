//bStart
If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	app_Log_Usage("log"; "PS MR"; "Start")
	makingReadyOn:=PS_MakeReadyTimerJobStart
	OBJECT SET ENABLED:C1123(bStop; True:C214)
	OBJECT SET ENABLED:C1123(bStart; False:C215)
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 