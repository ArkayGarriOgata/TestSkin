//%attributes = {"publishedWeb":true}
//PS_MakeReadyTimerSet

C_LONGINT:C283($1; <>pidTimer; $seconds)
C_TIME:C306($time)

If (Count parameters:C259=1)
	$seconds:=$1
	OK:=1
Else 
	$time:=?01:01:01?
	$time:=Time:C179(Request:C163("Enter the time limit:"; String:C10($time; HH MM SS:K7:1); "Set"; "Cancel"))
	$seconds:=$time+0
End if 

If (OK=1) & (<>pidTimer#0)
	SET PROCESS VARIABLE:C370(<>pidTimer; iLimit; $seconds)
	zwStatusMsg("SET TIMER"; String:C10($seconds)+" = Limit  ")
End if 