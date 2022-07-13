If (email_validate_address(emailCCEntry))
	If (Position:C15(emailCCEntry; [Addresses:30]RequestForModeEmailCC:45)=0)
		[Addresses:30]RequestForModeEmailCC:45:=[Addresses:30]RequestForModeEmailCC:45+emailCCEntry+", \r"
		
	Else 
		uConfirm("Remove "+emailCCEntry+" from the list?"; "Remove"; "Keep")
		If (ok=1)
			[Addresses:30]RequestForModeEmailCC:45:=Replace string:C233([Addresses:30]RequestForModeEmailCC:45; (emailCCEntry+", \r"); "")
		End if 
	End if 
	
	
Else 
	uConfirm(emailCCEntry+" doesn't appear valid."; "I'm sure"; "Try again")
	If (ok=0)
		GOTO OBJECT:C206(emailCCEntry)
		
	Else 
		
		If (Position:C15(emailCCEntry; [Addresses:30]RequestForModeEmailCC:45)=0)
			[Addresses:30]RequestForModeEmailCC:45:=[Addresses:30]RequestForModeEmailCC:45+emailCCEntry+", \r"
		Else 
			uConfirm("Remove "+emailCCEntry+" from the list?"; "Remove"; "Keep")
			If (ok=1)
				[Addresses:30]RequestForModeEmailCC:45:=Replace string:C233([Addresses:30]RequestForModeEmailCC:45; (emailCCEntry+", \r"); "")
			End if 
		End if 
		
	End if 
End if 

emailCCEntry:=""