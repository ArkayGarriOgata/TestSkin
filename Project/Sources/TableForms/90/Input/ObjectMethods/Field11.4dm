//(s)quanty [issuetickets] input
If (Self:C308-><0)
	ALERT:C41("You may not enter a negative number.")
	Self:C308->:=0
End if 
//