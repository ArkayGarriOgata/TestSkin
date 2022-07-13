//OM: Button4() -> 
//@author mlb - 8/1/02  14:26
If (Length:C16(sCriterion1)=8)
	$email:=Request:C163("What is your email address?"; Email_WhoAmI)
	If (ok=1)
		Job_revisionNoticeSet(sCriterion1; $email)
	Else 
		BEEP:C151
	End if 
Else 
	BEEP:C151
	zwStatusMsg("ERROR"; "Enter the Jobform number first")
End if 