If (dDate<4D_Current_date)
	BEEP:C151
	ALERT:C41("You realize that the past cannot be changed by a computer."; "Just do it")
	//dDate:=!00/00/00!
End if 

If (dDate>(4D_Current_date+365))
	BEEP:C151
	ALERT:C41("Wow, you really are a planner, looking that far in the future!"; "Shut up")
	//dDate:=!00/00/00!
End if 
//