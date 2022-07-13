delayUntil:=TSTimeStamp(delayUntilDate; delayUntilTime)
$now:=TSTimeStamp
$seconds:=delayUntil-$now
lValue1:=Int:C8($seconds/3600)
lValue2:=Int:C8(($seconds-(lValue1*3600))/60)

rDelayb1:=0
rDelayb2:=0
rDelayb3:=1
GOTO OBJECT:C206(delayUntilDate)