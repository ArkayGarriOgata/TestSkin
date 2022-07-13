//see PS_MakeReadyTimerStop
If (util_getPIN)
	C_TIME:C306($elapseTime; $start; $stop)
	running:=False:C215
	$elapseTime:=Current time:C178-tStart
	ALERT:C41("Elapse = "+String:C10($elapseTime; HH MM SS:K7:1))
End if 