//Layout Proc.: ChangeHistory()  030398  MLB
Case of 
	: (In break:C113) & (Level:C101=1)
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5)
		//    
End case 
//