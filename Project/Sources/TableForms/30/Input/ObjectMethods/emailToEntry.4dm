If (email_validate_address(emailToEntry))
	If (Position:C15(emailToEntry; [Addresses:30]RequestForModeEmailTo:17)=0)
		[Addresses:30]RequestForModeEmailTo:17:=[Addresses:30]RequestForModeEmailTo:17+emailToEntry+", \r"
		
	Else 
		uConfirm("Remove "+emailToEntry+" from the list?"; "Remove"; "Keep")
		If (ok=1)
			[Addresses:30]RequestForModeEmailTo:17:=Replace string:C233([Addresses:30]RequestForModeEmailTo:17; (emailToEntry+", \r"); "")
		End if 
	End if 
	
Else 
	uConfirm(emailToEntry+" doesn't appear valid."; "I'm sure"; "Try again")
	If (ok=0)
		GOTO OBJECT:C206(emailToEntry)
		
	Else 
		If (Position:C15(emailToEntry; [Addresses:30]RequestForModeEmailTo:17)=0)
			[Addresses:30]RequestForModeEmailTo:17:=[Addresses:30]RequestForModeEmailTo:17+emailToEntry+", \r"
			
		Else 
			uConfirm("Remove "+emailToEntry+" from the list?"; "Remove"; "Keep")
			If (ok=1)
				[Addresses:30]RequestForModeEmailTo:17:=Replace string:C233([Addresses:30]RequestForModeEmailTo:17; (emailToEntry+", \r"); "")
			End if 
		End if 
		
	End if 
End if 

emailToEntry:=""