//OM: bLoad() -> 
//@author mlb - 12/4/01  14:29
CUT NAMED SELECTION:C334([ProductionSchedules:110]; "hold")

C_LONGINT:C283(rightWin; topWin; rightWin; topWin)  //will be used to position the interval window when it opens
GET WINDOW RECT:C443(leftWin; topWin; rightWin; bottomWin)

SF_CalendarIntervals(sCriterion1)
USE NAMED SELECTION:C332("hold")
If (<>fContinue)  //assert sort indicator
	b4:=0
	b7:=0
	b6:=0
	b8:=1
	b5:=0
End if 
