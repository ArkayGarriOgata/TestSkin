//%attributes = {"publishedWeb":true}
//rRptCOShortages()   --JML    7/20/93
//[orderline] shortages report

READ ONLY:C145([Customers:16])
If (Records in selection:C76([Customers_Orders:40])#0)
	RELATE MANY SELECTION:C340([Customers_Order_Lines:41]OrderNumber:1)
	If (Records in selection:C76([Customers_Order_Lines:41])#0)
		util_PAGE_SETUP(->[Customers_Order_Lines:41]; "RptShortages")
		PRINT SETTINGS:C106
		If (ok=1)
			// CREATE SET([Finished_Goods];"FGSet")  `save selection because during phase sear
			FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "RptShortages")
			iPage:=1
			xReptTitle:="Finished Goods-Shortage Report"
			ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4; >; [Customers_Order_Lines:41]OrderNumber:1; >)
			BREAK LEVEL:C302(1; 1)
			ACCUMULATE:C303([Customers_Order_Lines:41]Quantity:6)  //nobdy cares about this-must be here though
			PRINT SELECTION:C60([Customers_Order_Lines:41]; *)
			FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "List")
			// USE SET("FGSet")
			// CLEAR SET("FGSet")
		End if 
	Else 
		ALERT:C41("Nothing in the current selection of Order items.")
	End if 
End if 
READ WRITE:C146([Customers:16])