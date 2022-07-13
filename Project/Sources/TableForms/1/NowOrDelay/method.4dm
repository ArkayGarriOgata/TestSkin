//FM:  NowOrDelay()  110199  mlb
//on load
If (uProcessName(Current process:C322)#"bBatch_Runner")
	rDelayb1:=1
	rDelayb2:=0
	rDelayb3:=0
	lValue1:=0
	lValue2:=0
	
	delayUntilDate:=Current date:C33
	delayUntilTime:=Current time:C178
	delayUntil:=TSTimeStamp(delayUntilDate; delayUntilTime)
	
Else 
	rDelayb1:=0
	rDelayb2:=0
	rDelayb3:=1
	lValue1:=0
	lValue2:=0
	$now:=TSTimeStamp
	$seconds:=delayUntil-$now
	lValue1:=Int:C8($seconds/3600)
	lValue2:=Int:C8(($seconds-(lValue1*3600))/60)
	TS2DateTime(delayUntil; ->delayUntilDate; ->delayUntilTime)
End if 
//tTime:=†18:00:00†  `default to after work