Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Job_MakeVsBuy:97]))
			[Job_MakeVsBuy:97]id:1:=app_GetPrimaryKey
			[Job_MakeVsBuy:97]RequestedBy:5:=User_ResolveInitials(<>zResp)
			[Job_MakeVsBuy:97]RequestedOn:6:=4D_Current_date
			If (Length:C16(<>jobform)=8)
				[Job_MakeVsBuy:97]JobFormId:2:=<>jobform
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
			End if 
		End if 
		
		READ ONLY:C145([Job_Forms:42])
		READ ONLY:C145([Jobs:15])
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Job_MakeVsBuy:97]JobFormId:2)
		RELATE ONE:C42([Job_Forms:42]JobNo:2)
End case 
