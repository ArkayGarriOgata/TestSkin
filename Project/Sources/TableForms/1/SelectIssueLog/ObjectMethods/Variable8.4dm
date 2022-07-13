//(s) sJobForm
If (Self:C308->#"")
	
	If (Length:C16(Self:C308->)>8)
		ALERT:C41("Invalid Job Form entry.")
		Self:C308->:=""
	Else 
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=Self:C308->)
		
		If (Records in selection:C76([Job_Forms:42])=0)
			ALERT:C41("Entered Job or Job form was not found.")
			Self:C308->:=""
		End if 
	End if 
End if 
//