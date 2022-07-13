//(s) sjobform [control]directbillink
If (Self:C308->#"")
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=Self:C308->)
	
	If (Records in selection:C76([Job_Forms:42])=0)
		Self:C308->:=""
		ALERT:C41("The Job Form entered was not found.")
	End if 
End if 
//