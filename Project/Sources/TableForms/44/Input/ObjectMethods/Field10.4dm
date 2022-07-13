//OM: OrderItem() -> 
//@author mlb - 11/13/01  12:47

If (Self:C308->#"Excess") & (Self:C308->#"Fill-In") & (Self:C308->#"Rerun") & (Self:C308->#"FORECAST") & (Self:C308->#"DF@")  //if the entered value is not either of these validate orderline number
	READ ONLY:C145([Customers_Order_Lines:41])
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=Self:C308->)
	
	Case of 
		: (Records in selection:C76([Customers_Order_Lines:41])=1)
			
			If ([Customers_Order_Lines:41]ProductCode:5#[Job_Forms_Items:44]ProductCode:3)
				ALERT:C41("The CPN of the Entered Orderline ID ("+Self:C308->+") DOES NOT Match the CPN Entered in Selected Job Form Item."+<>sCr+"Please Investigate, or Call x328.")
				Self:C308->:=""
			End if 
			
		: (Records in selection:C76([Customers_Order_Lines:41])>1)
			ALERT:C41("The Entered Orderline Id is NOT Unique.  Please Enter a Unique Orderline ID.")
			Self:C308->:=""
			
		Else   //=0
			ALERT:C41("The Orderline Id Entered DOES NOT EXIST."+"  You MUST Enter a Valid OrderLine to Accept this Job Form.")
			Self:C308->:=""
	End case 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
		
		UNLOAD RECORD:C212([Customers_Order_Lines:41])
		
	Else 
		
		// YOU HAVE READ ONLY MODE
		
	End if   // END 4D Professional Services : January 2019 
	
	READ WRITE:C146([Customers_Order_Lines:41])
End if 
//eos