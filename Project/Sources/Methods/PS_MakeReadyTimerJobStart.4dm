//%attributes = {"publishedWeb":true}
//PS_MakeReadyTimerJobStart

$0:=[ProductionSchedules:110]JobSequence:8
MRhours:=PS_getMRhours

If (MRhours#?00:00:00?)
	PS_MakeReadyTimer(1)
	PS_MakeReadyTimerSet(MRhours+0)
	PS_MakeReadyTimerStart([ProductionSchedules:110]JobSequence:8)
End if 