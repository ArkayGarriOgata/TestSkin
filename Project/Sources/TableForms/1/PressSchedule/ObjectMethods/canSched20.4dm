//OM: bNotify() -> 
//@author mlb - 12/5/01  12:01

$js:=Request:C163("What sequence is causing a problem?")
If (ok=1)
	CUT NAMED SELECTION:C334([ProductionSchedules:110]; "testLock")
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$js)
	If (Records in selection:C76([ProductionSchedules:110])=1)
		If (fLockNLoad(->[ProductionSchedules:110]))
			ALERT:C41("we're in")
		End if 
	Else 
		BEEP:C151
	End if 
	USE NAMED SELECTION:C332("testLock")
End if 
