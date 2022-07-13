//%attributes = {"publishedWeb":true}
//PM:  JML_newViaOrder  110899  mlb
//formerly  `Procedure: uCreateJML 051295 
//create a new JobMasterLog record see also uCreateJobhdr

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=(String:C10([Customers_Orders:40]JobNo:44)+"@"))  //1/26/95
If (Records in selection:C76([Job_Forms_Master_Schedule:67])=0)
	If ($1#"CONTRACT")  //•060195  MLB  UPR 184     
		CREATE RECORD:C68([Job_Forms_Master_Schedule:67])  //1/26/95
		[Job_Forms_Master_Schedule:67]Salesman:1:=[Customers_Orders:40]SalesRep:13
		[Job_Forms_Master_Schedule:67]Customer:2:=[Customers_Orders:40]CustomerName:39
		[Job_Forms_Master_Schedule:67]PO_No:3:=[Customers_Orders:40]PONumber:11
		[Job_Forms_Master_Schedule:67]JobForm:4:=String:C10([Customers_Orders:40]JobNo:44)+".**"
		[Job_Forms_Master_Schedule:67]Line:5:=[Customers_Orders:40]CustomerLine:22
		[Job_Forms_Master_Schedule:67]EnterOrderDate:9:=[Customers_Orders:40]DateOpened:6
		[Job_Forms_Master_Schedule:67]CustWantDate:10:=[Estimates:17]DateCustomerWant:23
		[Job_Forms_Master_Schedule:67]Comment:22:=""  //"This is a place holder created when order number "+String(vord)+" was entered."
		If (Length:C16([Customers_Orders:40]ProjectNumber:53)=5)
			[Job_Forms_Master_Schedule:67]ProjectNumber:26:=[Customers_Orders:40]ProjectNumber:53
		Else 
			[Job_Forms_Master_Schedule:67]ProjectNumber:26:=Substring:C12([Estimates:17]EstimateNo:1; 1; 6)
		End if 
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
		zwStatusMsg("JobTrack"; " Job form "+[Job_Forms_Master_Schedule:67]JobForm:4+" has been placed on the Job Master Log.")
		$0:=1
	Else 
		$0:=0
	End if 
Else 
	$0:=0
End if 