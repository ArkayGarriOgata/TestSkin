//(LP) [OrderChgHistory]'ChgOrderRpt
Case of 
	: (Form event code:C388=On Load:K2:1)
		RELATE ONE:C42([Customers_Order_Change_Orders:34]OrderNo:5)
		RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
		ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
		
End case 
//EOP