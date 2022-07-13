// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/08/09, 16:41:52
// ----------------------------------------------------
// Method: Object Method: fix_orderlines
// ----------------------------------------------------

//find orderlines using this fg
READ WRITE:C146([Customers_Order_Lines:41])
READ WRITE:C146([Customers_Orders:40])
READ WRITE:C146([Customers_ReleaseSchedules:46])
READ ONLY:C145([Customers:16])

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1)
If (Records in selection:C76([Customers_Order_Lines:41])>0)
	While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
		//update the order header also
		RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
		
		//do the updates
		[Customers_Order_Lines:41]CustID:4:=[Finished_Goods:26]CustID:2
		[Customers_Order_Lines:41]Classification:29:=[Finished_Goods:26]ClassOrType:28
		[Customers_Order_Lines:41]OrderType:22:=[Finished_Goods:26]OrderType:59
		[Customers_Order_Lines:41]CustomerLine:42:=[Finished_Goods:26]Line_Brand:15
		
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Order_Lines:41]CustID:4)
		[Customers_Order_Lines:41]CustomerName:24:=[Customers:16]Name:2  //CUST_getName ([Customers_Order_Lines]CustID)
		[Customers_Order_Lines:41]edi_arkay_planner:68:=[Customers:16]PlannerID:5
		If ([Customers_Order_Lines:41]OrderType:22="Promotional")
			[Customers_Order_Lines:41]OverRun:25:=[Customers:16]Run_Over_Promo_Order:65
			[Customers_Order_Lines:41]UnderRun:26:=[Customers:16]Run_Under_Promo_Order:66
		Else 
			[Customers_Order_Lines:41]OverRun:25:=[Customers:16]Run_Over_Regular_Order:63
			[Customers_Order_Lines:41]UnderRun:26:=[Customers:16]Run_Under_Regular_Order:64
		End if 
		[Customers_Order_Lines:41]ProjectNumber:50:=[Finished_Goods:26]ProjectNumber:82
		//If ([Customers_Orders]CustID#[Customers_Order_Lines]CustID)
		[Customers_Orders:40]CustID:2:=[Customers_Order_Lines:41]CustID:4
		[Customers_Orders:40]CustomerName:39:=[Customers_Order_Lines:41]CustomerName:24
		[Customers_Orders:40]CustomerLine:22:=[Customers_Order_Lines:41]CustomerLine:42
		[Customers_Orders:40]CustomerService:47:=[Customers:16]CustomerService:46
		[Customers_Orders:40]PlannedBy:30:=[Customers:16]PlannerID:5
		[Customers_Orders:40]SalesCoord:46:=[Customers:16]SalesCoord:45
		[Customers_Orders:40]SalesRep:13:=[Customers:16]SalesmanID:3
		//End if 
		SET QUERY LIMIT:C395(0)
		
		SAVE RECORD:C53([Customers_Order_Lines:41])
		SAVE RECORD:C53([Customers_Orders:40])
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
					[Customers_ReleaseSchedules:46]CustID:12:=[Finished_Goods:26]CustID:2
					[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
					[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15
					SAVE RECORD:C53([Customers_ReleaseSchedules:46])
					NEXT RECORD:C51([Customers_ReleaseSchedules:46])
				End while 
			End if 
			
		Else 
			
			C_TEXT:C284($CustID; $ProjectNumber; $Line_Brand)
			
			$CustID:=[Finished_Goods:26]CustID:2
			$ProjectNumber:=[Finished_Goods:26]ProjectNumber:82
			$Line_Brand:=[Finished_Goods:26]Line_Brand:15
			
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				
				APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12:=$CustID)
				APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40:=$ProjectNumber)
				APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerLine:28:=$Line_Brand)
				
			End if 
			
		End if   // END 4D Professional Services : January 2019 
		
		NEXT RECORD:C51([Customers_Order_Lines:41])
	End while 
	
	REDUCE SELECTION:C351([Customers:16]; 0)
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	
Else 
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
				[Customers_ReleaseSchedules:46]CustID:12:=[Finished_Goods:26]CustID:2
				[Customers_ReleaseSchedules:46]ProjectNumber:40:=[Finished_Goods:26]ProjectNumber:82
				[Customers_ReleaseSchedules:46]CustomerLine:28:=[Finished_Goods:26]Line_Brand:15
				SAVE RECORD:C53([Customers_ReleaseSchedules:46])
				NEXT RECORD:C51([Customers_ReleaseSchedules:46])
			End while 
		End if 
		
		
	Else 
		
		C_TEXT:C284($CustID; $ProjectNumber; $Line_Brand)
		
		$CustID:=[Finished_Goods:26]CustID:2
		$ProjectNumber:=[Finished_Goods:26]ProjectNumber:82
		$Line_Brand:=[Finished_Goods:26]Line_Brand:15
		
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12:=$CustID)
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40:=$ProjectNumber)
			APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerLine:28:=$Line_Brand)
			
		End if 
		
		
	End if   // END 4D Professional Services : January 2019 
	
	uConfirm("No orders found for "+[Finished_Goods:26]ProductCode:1; "OK"; "Help")
End if 