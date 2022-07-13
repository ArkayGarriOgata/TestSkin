If ([Customers_Order_Lines:41]ProductCode:5#"")
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Customers_Order_Lines:41]CustID:4+":"+[Customers_Order_Lines:41]ProductCode:5)
	If (Records in selection:C76([Finished_Goods:26])=0)
		BEEP:C151
		ALERT:C41([Customers_Order_Lines:41]ProductCode:5+" does not exist for this customer.")
		
	Else 
		// Modified by: Mel Bohince (11/13/15) 
		pendingChange:=pendingChange+"ProductCode Changed from "+Old:C35([Customers_Order_Lines:41]ProductCode:5)+" to "+[Customers_Order_Lines:41]ProductCode:5+Char:C90(Carriage return:K15:38)
		
		[Customers_Order_Lines:41]Cost_Per_M:7:=[Finished_Goods:26]LastCost:26
		
	End if 
End if 
UNLOAD RECORD:C212([Finished_Goods:26])
//