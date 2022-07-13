Case of 
	: (User in group:C338(Current user:C182; "Administration"))
		Case of 
			: ([Usage_Problem_Reports:84]Status:20="Reviewed")
				If ([Usage_Problem_Reports:84]Reviewer:7="")
					[Usage_Problem_Reports:84]Reviewer:7:=<>zResp
				End if 
				
			: ([Usage_Problem_Reports:84]Status:20="Returned")
				[Usage_Problem_Reports:84]PriorityNumber:19:=999
				[Usage_Problem_Reports:84]Returned:4:=4D_Current_date
				[Usage_Problem_Reports:84]Analyst:8:=<>zResp
				
		End case 
		
	Else 
		BEEP:C151
		ALERT:C41("You must be in the Administration group to change the status.")
		[Usage_Problem_Reports:84]Status:20:="New"
End case 

UPRstatusChg
//