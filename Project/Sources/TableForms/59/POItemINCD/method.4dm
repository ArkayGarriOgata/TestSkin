//(lop) POItemINCD
util_alternateBackground
If (Form event code:C388=On Load:K2:1)
	If (Records in selection:C76([Purchase_Orders_Job_forms:59])#0)
		
		If ([Purchase_Orders_Job_forms:59]JobFormID:2="")
			
			If (Length:C16([Purchase_Orders:11]DefaultJobId:3)=8)
				QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Purchase_Orders:11]DefaultJobId:3)
				If (Records in selection:C76([Job_Forms:42])#0)
					[Purchase_Orders_Job_forms:59]JobFormID:2:=[Purchase_Orders:11]DefaultJobId:3
					[Purchase_Orders_Job_forms:59]POItemKey:1:=[Purchase_Orders_Items:12]POItemKey:1
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
					ALERT:C41([Purchase_Orders_Job_forms:59]JobFormID:2+" is not a valid Job Form ID.")
					[Purchase_Orders_Job_forms:59]JobFormID:2:=""
					[Purchase_Orders_Job_forms:59]NeedDate:3:=!00-00-00!
					[Purchase_Orders_Job_forms:59]QtyRequired:4:=0
				End if 
				UNLOAD RECORD:C212([Job_Forms:42])
				UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
				
			End if 
			
		End if 
		
	End if 
End if 
