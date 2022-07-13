//%attributes = {"publishedWeb":true}
util_PAGE_SETUP(->[Customers_Order_Lines:41]; "Expiration Summ")
PRINT SETTINGS:C106
If (ok=1)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0)
	CONFIRM:C162("All orders with open quantities?")
	If (ok=0)
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Customers_Order_Lines:41])
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
	End if 
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustomerName:24; >; [Customers_Order_Lines:41]ProductCode:5; >)
		
		BREAK LEVEL:C302(1)
		ACCUMULATE:C303(real1; real2; real3)
		FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "Expiration Summ")
		PRINT SELECTION:C60([Customers_Order_Lines:41]; *)
		FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "List")
		
	Else 
		BEEP:C151
		ALERT:C41("No order records found that meet that criterion.")
		
	End if 
	
End if   //ok

//