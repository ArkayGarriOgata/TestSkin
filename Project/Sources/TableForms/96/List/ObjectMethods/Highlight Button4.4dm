<>BOL:=Num:C11(Request:C163("Enter Shipper's Number: (BOL#) to Invoice"; String:C10(<>BOL); "Continue..."; "Cancel"))
If (<>BOL>0) & (ok=1)
	QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=<>BOL)
	
	QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]BillOfLadingNumber:3=<>BOL)
	If (Records in selection:C76([Customers_Invoices:88])>0)
		BEEP:C151
		ALERT:C41("Tell Debra, x244, to void old invoice#"+String:C10([Customers_Invoices:88]InvoiceNumber:1))
	End if 
	REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
	//method to create a new invoice here
	$invoice:=Invoice_GetNewNumber
	If ($invoice>0)
		START TRANSACTION:C239
		Invoice_New($invoice)
		[Customers_Invoices:88]BillOfLadingNumber:3:=<>BOL
		[Customers_Invoices:88]OrderLine:4:="WIP"
		[Customers_Invoices:88]ReleaseNumber:5:=0
		[Customers_Invoices:88]CustomerID:6:="00199"
		[Customers_Invoices:88]Invoice_Date:7:=4D_Current_date
		[Customers_Invoices:88]InvComment:12:="  See Packing Slip for Bill of Lading "+String:C10(<>BOL)
		//[Invoices]SalesPerson:=[OrderLines]SalesRep
		[Customers_Invoices:88]ShipTo:9:=[Customers_Bills_of_Lading:49]ShipTo:3
		[Customers_Invoices:88]BillTo:10:=[Customers_Bills_of_Lading:49]BillTo:4
		[Customers_Invoices:88]CustomersPO:11:="See O/S Agreement"
		[Customers_Invoices:88]InvType:13:="Debit"  //mark this record as a credit/return for Dynamics
		[Customers_Invoices:88]ProductCode:14:="See Packing Slip"
		//[Customers_Invoices]CommissionPlan:=commissionLastPln
		[Customers_Invoices:88]CommissionPayable:21:=0  //fSalesCommission ("Normal";[Invoices]OrderLine;$units)
	End if 
	
	
	If ($invoice>0)
		CUT NAMED SELECTION:C334([WMS_SerializedShippingLabels:96]; "beforeRec")
		QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]ShippersNumber:14=<>BOL)
		zwStatusMsg("BOL="+String:C10(<>BOL); String:C10(Records in selection:C76([WMS_SerializedShippingLabels:96]))+" container SSCC's found.")
		$succeed:=True:C214
		$extended:=0
		$finishedPrice:=0
		$qty:=0
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([WMS_SerializedShippingLabels:96])
			
			
		Else 
			
			// you have query on line 35 you don't need first
			
		End if   // END 4D Professional Services : January 2019 First record
		
		For ($i; 1; Records in selection:C76([WMS_SerializedShippingLabels:96]))
			If (fLockNLoad(->[WMS_SerializedShippingLabels:96]))
				[WMS_SerializedShippingLabels:96]InvoiceNumber:18:=$invoice
				If ([WMS_SerializedShippingLabels:96]CPN:2#"MIXED")
					
				End if 
				$qty:=$qty+[WMS_SerializedShippingLabels:96]Quantity:4
				$extended:=$extended+[WMS_SerializedShippingLabels:96]WIPprice:19
				$finishedPrice:=$finishedPrice+[WMS_SerializedShippingLabels:96]FGprice:20
				$numFG:=qryFinishedGood("#CPN"; [WMS_SerializedShippingLabels:96]CPN:2)  //
				[Customers_Invoices:88]CustomerLine:20:=[Finished_Goods:26]Line_Brand:15
				If (Length:C16([Customers_Invoices:88]GL_CODE:23)=0)
					QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Finished_Goods:26]ClassOrType:28)
					[Customers_Invoices:88]GL_CODE:23:=Invoice_getGLcode
				End if 
				SAVE RECORD:C53([WMS_SerializedShippingLabels:96])
			Else 
				$succeed:=False:C215
				BEEP:C151
				ALERT:C41([WMS_SerializedShippingLabels:96]HumanReadable:5+" is locked, could not be marked as Invoiced.")
			End if 
			NEXT RECORD:C51([WMS_SerializedShippingLabels:96])
		End for 
		
		If ($succeed)
			[Customers_Invoices:88]Quantity:15:=$qty
			[Customers_Invoices:88]PricingUOM:17:="M"
			[Customers_Invoices:88]Terms:18:="Net 90"
			[Customers_Invoices:88]ExtendedPrice:19:=Round:C94($extended; 2)
			[Customers_Invoices:88]PricePerUnit:16:=$extended/$qty*1000
			[Customers_Invoices:88]InvComment:12:="Finished Price is "+String:C10(Round:C94($finishedPrice; 2))+[Customers_Invoices:88]InvComment:12
			SAVE RECORD:C53([Customers_Invoices:88])
			VALIDATE TRANSACTION:C240
			
			REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
			
		Else 
			CANCEL TRANSACTION:C241
			REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
			BEEP:C151
			ALERT:C41(String:C10(<>BOL)+" could not be Invoiced.")
		End if 
		
		USE NAMED SELECTION:C332("beforeRec")
		REDUCE SELECTION:C351([Finished_Goods_Classifications:45]; 0)
		REDUCE SELECTION:C351([Customers_Bills_of_Lading:49]; 0)
		REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		
	Else 
		BEEP:C151
		BEEP:C151
	End if 
	
Else 
	BEEP:C151
	BEEP:C151
End if 




