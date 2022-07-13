//(s) JObform [issueticeks] input

If (Self:C308->#"")
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=Substring:C12(Self:C308->; 1; 8))
	
	If (Records in selection:C76([Job_Forms:42])=0)
		ALERT:C41("Entered Job Form was not found."+Char:C90(13)+"Please try again.")
		Self:C308->:=""
	End if 
End if 
//