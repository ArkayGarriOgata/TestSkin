C_TIME:C306($seconds)
If (util_getPIN)
	$seconds:=?00:01:00?  //see PS_MakeReadyTimerSet
	$seconds:=Time:C179(Request:C163("Enter time limit in HH:MM:SS format:"; String:C10($seconds; HH MM SS:K7:1); "Set"; "Cancel"))
	If (ok=1)
		iLimit:=$seconds+0
	End if 
End if 