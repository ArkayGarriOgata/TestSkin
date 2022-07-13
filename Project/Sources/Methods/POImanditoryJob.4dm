//%attributes = {"publishedWeb":true}
//PM:  POImanditoryJob  9/28/00  mlb
//make sure direct purchase records specify a job

$0:=False:C215

QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Purchase_Orders_Items:12]POItemKey:1; *)
QUERY:C277([Purchase_Orders_Job_forms:59];  & ; [Purchase_Orders_Job_forms:59]JobFormID:2#"")
If (Records in selection:C76([Purchase_Orders_Job_forms:59])=0)  //no jobs listed, see if required
	
	If (RMG_is_DirectPurchase([Purchase_Orders_Items:12]Commodity_Key:26))
		READ ONLY:C145([Job_Forms:42])
		READ ONLY:C145([Job_Forms_Master_Schedule:67])
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Purchase_Orders:11]DefaultJobId:3)
		If (Records in selection:C76([Job_Forms:42])#0)
			CREATE RECORD:C68([Purchase_Orders_Job_forms:59])
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
			uConfirm([Purchase_Orders_Items:12]Commodity_Key:26+" is a Direct Purchase receipt type, specify a jobform to continue."; "OK"; "Help")
			$0:=True:C214
		End if 
		UNLOAD RECORD:C212([Job_Forms:42])
		UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
	End if 
End if 