//(s) bReOpen
//takes needed actions to close out a Job form/Job
//• 12/2/97 cs created
// Modified by: Mel Bohince (9/9/15) offer to leave dates complete and closed

If ([Job_Forms:42]Status:6="Closed")
	uConfirm("Change the status of this form from Closed to WIP?"; "WIP"; [Job_Forms:42]Status:6)
	If (ok=1)
		READ WRITE:C146([Jobs:15])
		READ WRITE:C146([Job_Forms_Master_Schedule:67])
		<>jobform:=[Job_Forms:42]JobFormID:5
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=Num:C11(Substring:C12(<>jobform; 1; 5)))
		[Jobs:15]Status:4:="WIP"
		[Job_Forms:42]Status:6:="WIP"
		uConfirm("Clear the COMPLETED date?"; "Clear"; "No touch")
		If (ok=1)
			[Job_Forms:42]Completed:18:=!00-00-00!
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=<>jobform)
			[Job_Forms_Master_Schedule:67]DateComplete:15:=!00-00-00!
			SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		End if 
		uConfirm("Clear the CLOSED date?"; "Clear"; "No touch")
		If (ok=1)
			[Jobs:15]CloseDate:17:=!00-00-00!
			[Job_Forms:42]ClosedDate:11:=!00-00-00!
		End if 
		SAVE RECORD:C53([Job_Forms:42])
		SAVE RECORD:C53([Jobs:15])
		
		
		//REDUCE SELECTION([JOB];0)
		REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
		APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]FormClosed:5:=False:C215)
		
		//QUERY([Purchase_Orders];[Purchase_Orders]PONo=[Job_Forms]InkPONumber)
		//If (Records in selection([Purchase_Orders])=1)
		//[Purchase_Orders]Status:="Approved"
		//[Purchase_Orders]INX_autoPO:=True
		//[Purchase_Orders]StatusTrack:="Job Reopened"+Char(13)+[Purchase_Orders]StatusTrack
		//[Purchase_Orders]StatusBy:=<>zResp
		//[Purchase_Orders]StatusDate:=4D_Current_date
		//[Purchase_Orders]Comments:="Job Reopened"+Char(13)+[Purchase_Orders]Comments
		//SAVE RECORD([Purchase_Orders])
		//RELATE MANY([Purchase_Orders]PONo)
		//APPLY TO SELECTION([Purchase_Orders_Items];[Purchase_Orders_Items]Qty_Open:=[Purchase_Orders_Items]Qty_Ordered-[Purchase_Orders_Items]Qty_Received)
		//End if 
		//REDUCE SELECTION([Purchase_Orders];0)
		//REDUCE SELECTION([Purchase_Orders_Items];0)
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("This form does not appear to be closed.")
End if 
