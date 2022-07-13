READ ONLY:C145([Job_Forms:42])
READ ONLY:C145([Jobs:15])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_MakeVsBuy:97]JobFormId:2)
If (Records in selection:C76([Job_Forms:42])=1)
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
	[Job_MakeVsBuy:97]CustID:8:=[Jobs:15]CustID:2
	[Job_MakeVsBuy:97]Line:9:=[Jobs:15]Line:3
	
Else 
	uConfirm("Jobform "+[Job_MakeVsBuy:97]JobFormId:2+" was not found."; "Try Again"; "Help")
	[Job_MakeVsBuy:97]JobFormId:2:=""
End if 