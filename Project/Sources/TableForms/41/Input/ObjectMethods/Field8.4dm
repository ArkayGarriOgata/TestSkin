If ([Customers_Order_Lines:41]ProductCode:5#"")
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=[Customers_Order_Lines:41]CustID:4+":"+[Customers_Order_Lines:41]ProductCode:5)
	If (Records in selection:C76([Finished_Goods:26])=0)
		BEEP:C151
		ALERT:C41([Estimates_Carton_Specs:19]ProductCode:5+" does not exist for this customer.")
		
	Else 
		[Customers_Order_Lines:41]Cost_Per_M:7:=[Finished_Goods:26]LastCost:26
		
	End if 
End if 
UNLOAD RECORD:C212([Finished_Goods:26])
//