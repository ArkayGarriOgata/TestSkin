
//Script: t3b()  080195  MLB
//•080195  MLB  UPR 1490
If ([Customers:16]ID:1#[Finished_Goods:26]CustID:2)
	READ ONLY:C145([Customers:16])
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
End if 

If ([Salesmen:32]ID:1#[Customers:16]SalesmanID:3)
	READ ONLY:C145([Salesmen:32])
	QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=[Customers:16]SalesmanID:3)
End if 

t3b:=[Finished_Goods:26]CustID:2+" - "+[Customers:16]Name:2+"      "+[Customers:16]SalesmanID:3+" - "+[Salesmen:32]FirstName:3+" "+[Salesmen:32]LastName:2
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	USE SET:C118("OpenOrders")  //•080195  MLB  UPR 1490
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	CREATE SET:C116([Customers_Order_Lines:41]; "OneCustOpenOrders")
Else 
	
	USE SET:C118("OpenOrders")  //•080195  MLB  UPR 1490
	SET QUERY DESTINATION:C396(Into set:K19:2; "OneCustOpenOrders")
	QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=[Finished_Goods:26]CustID:2)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
End if   // END 4D Professional Services : January 2019

If (Not:C34(<>fContinue))
	BEEP:C151
	uConfirm("The only way to stop this report is to Quit."; "Quit"; "Continue")
	If (ok=1)
		QUIT 4D:C291
	End if 
	
End if 
//