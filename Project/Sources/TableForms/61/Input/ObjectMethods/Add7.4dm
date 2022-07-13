[Job_Forms_Machine_Tickets:61]Run_Act:7:=rElapse+[Job_Forms_Machine_Tickets:61]Run_Act:7

tsElapse:="00:00"
rElapse:=0
tSecondsStarted:=TSTimeStamp
tsStarted:=TS2String(tSecondsStarted)
tsStarted:=Substring:C12(tsStarted; 1; Length:C16(tsStarted)-3)