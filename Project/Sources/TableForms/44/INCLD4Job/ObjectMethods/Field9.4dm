// -------
// Method: [Job_Forms_Items].INCLD4Job.Field9   ( ) ->
//see also script bAccept & bPrint [Job_Forms]input
//•090899  mlb  UPR add rerun FORECAST

t10:=Uppercase:C13([Job_Forms_Items:44]Category:31)

If (Form event code:C388=On Data Change:K2:15)
	
	Case of   //see   // Method: [Job_Forms].Input.Button1 "Set All Orderlines To"
		: ([Job_Forms_Items:44]OrderItem:2="Excess")
			//allow
		: ([Job_Forms_Items:44]OrderItem:2="Fill-In")
			//allow
		: ([Job_Forms_Items:44]OrderItem:2="Rerun")
			//allow
		: ([Job_Forms_Items:44]OrderItem:2="FORECAST")
			//allow
		: ([Job_Forms_Items:44]OrderItem:2="DF@")  //delfor designation
			//allow
			
		: ([Job_Forms_Items:44]OrderItem:2="JC@")  //component designation
			//allow
			
		Else   //assume orderline entered
			READ ONLY:C145([Customers_Order_Lines:41])
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
			
			Case of 
				: (Records in selection:C76([Customers_Order_Lines:41])=1)
					If ([Customers_Order_Lines:41]ProductCode:5#[Job_Forms_Items:44]ProductCode:3)
						uConfirm("The CPN of the Entered Orderline ID ("+[Job_Forms_Items:44]OrderItem:2+") DOES NOT Match the CPN Entered in Selected Job Form Item.\r Please Investigate."; "OK"; "Help")
						//[Job_Forms_Items]OrderItem:=Old([Job_Forms_Items]OrderItem)
						GOTO OBJECT:C206([Job_Forms_Items:44]OrderItem:2)
					End if 
					
				: (Records in selection:C76([Customers_Order_Lines:41])>1)
					uConfirm("The Entered Orderline Id is NOT Unique.  Please Enter a Unique Orderline ID."; "OK"; "Help")
					[Job_Forms_Items:44]OrderItem:2:=Old:C35([Job_Forms_Items:44]OrderItem:2)
					GOTO OBJECT:C206([Job_Forms_Items:44]OrderItem:2)
					
				Else   //=0
					uConfirm("The Orderline Id Entered DOES NOT EXIST."+"  You MUST Enter a Valid OrderLine to Accept this Job Form."; "OK"; "Help")
					[Job_Forms_Items:44]OrderItem:2:=Old:C35([Job_Forms_Items:44]OrderItem:2)
					GOTO OBJECT:C206([Job_Forms_Items:44]OrderItem:2)
			End case 
	End case 
	
End if   //form event
