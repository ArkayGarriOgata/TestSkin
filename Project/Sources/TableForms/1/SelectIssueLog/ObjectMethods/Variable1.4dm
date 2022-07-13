//(s) bAccept
Case of 
	: (dDateEnd<dDateBegin) & (rbDate=1)
		ALERT:C41("That date range is invalid.  Try again.")
		REJECT:C38
	: (rbJob=1)
		
		If (Records in selection:C76([Job_Forms:42])=0)
			ALERT:C41("Invalid Job form selection.")
			REJECT:C38
		End if 
End case 
//