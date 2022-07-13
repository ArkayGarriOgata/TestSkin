QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Purchase_Orders_Job_forms:59]JobFormID:2)
If (Records in selection:C76([Job_Forms:42])#0)
	If ([Job_Forms:42]Status:6#"Closed")
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=[Purchase_Orders_Job_forms:59]JobFormID:2)
		If (Records in selection:C76([Job_Forms_Master_Schedule:67])#0) & ([Job_Forms_Master_Schedule:67]PressDate:25#!00-00-00!)
			[Purchase_Orders_Job_forms:59]NeedDate:3:=[Job_Forms_Master_Schedule:67]PressDate:25-1
		End if 
		If ([Purchase_Orders_Job_forms:59]NeedDate:3=!00-00-00!)
			[Purchase_Orders_Job_forms:59]NeedDate:3:=[Job_Forms:42]NeedDate:1
		End if 
		SAVE RECORD:C53([Purchase_Orders_Job_forms:59])
		
	Else 
		BEEP:C151
		uConfirm([Purchase_Orders_Job_forms:59]JobFormID:2+" is Closed."; "Try Again"; "Help")
		[Purchase_Orders_Job_forms:59]JobFormID:2:=""
		[Purchase_Orders_Job_forms:59]NeedDate:3:=!00-00-00!
		[Purchase_Orders_Job_forms:59]QtyRequired:4:=0
	End if 
Else 
	BEEP:C151
	uConfirm([Purchase_Orders_Job_forms:59]JobFormID:2+" is not a valid Job Form ID."; "Try Again"; "Help")
	[Purchase_Orders_Job_forms:59]JobFormID:2:=""
	[Purchase_Orders_Job_forms:59]NeedDate:3:=!00-00-00!
	[Purchase_Orders_Job_forms:59]QtyRequired:4:=0
End if 
UNLOAD RECORD:C212([Job_Forms:42])
UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
//