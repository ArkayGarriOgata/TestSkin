delayUntil:=TSTimeStamp+(lValue1*60*60)+(lValue2*60)
TS2DateTime(delayUntil; ->delayUntilDate; ->delayUntilTime)
GOTO OBJECT:C206(lValue1)
rDelayb1:=0
rDelayb2:=1
rDelayb3:=0