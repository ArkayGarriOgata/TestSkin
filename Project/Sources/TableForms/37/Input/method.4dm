Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Work_Orders:37]))
			[Work_Orders:37]id:1:=app_AutoIncrement(->[Work_Orders:37])
			[Work_Orders:37]Created:2:=4D_Current_date  //TSDateTime 
			[Work_Orders:37]Urgency:9:="Routine"
			[Work_Orders:37]Status:8:="New"
			[Work_Orders:37]OrderedBy:6:=<>zResp
		Else 
			//any restrictions?
		End if 
		
	: (Form event code:C388=On Data Change:K2:15)
		Case of 
			: ([Work_Orders:37]Finished:4#!00-00-00!)
				[Work_Orders:37]Status:8:="Done"
				
			: ([Work_Orders:37]Started:3#!00-00-00!)
				[Work_Orders:37]Status:8:="Started"
				
			: ([Work_Orders:37]Scheduled:10#!00-00-00!)
				[Work_Orders:37]Status:8:="Scheduled"
				
			Else 
				[Work_Orders:37]Status:8:="New"
		End case 
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		
	: (Form event code:C388=On Validate:K2:3)
		
End case 