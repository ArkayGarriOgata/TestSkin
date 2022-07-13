//(s) [user]preference'iminutes
If (iMinutes=0)
	uConfirm("Your Accepting this screen with 0 (zero) minutes will Disable the Notifier."+Char:C90(13)+"Disable the Notifier?")
	
	If (OK=1)
		ACCEPT:C269
	Else 
		REJECT:C38
	End if 
End if 
//