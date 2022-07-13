//(p) icomm [control]MoveRM
If (Self:C308->#"")
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=Self:C308->)
	
	Case of 
		: (Records in selection:C76([Job_Forms:42])=0)
			ALERT:C41("Entered JobForm NOT found.")
			Self:C308->:=""
			GOTO OBJECT:C206(Self:C308->)
		: (Records in selection:C76([Job_Forms:42])>1)
			ALERT:C41("Too Many JobForms found. Please enter a unique Jobform Id")
			GOTO OBJECT:C206(Self:C308->)
	End case 
End if 
//