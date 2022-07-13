//%attributes = {"publishedWeb":true}
//Procedure: uLinesLikeOrder()  051595  MLB
//so orderlines inherit order header info uniformly
//see also similar assignments in uChgOrderLines
//•051595  MLB  UPR 1508
//•060295  MLB  UPR 184
//•071195  MLB  UPR §
//• 4/20/98 cs users want to combine multiple divisions of same customer
//•5/04/00  mlb  pjt number
//  ie: cosmair
[Customers_Order_Lines:41]OrderNumber:1:=[Customers_Orders:40]OrderNumber:1  //•071195  MLB  UPR §
[Customers_Order_Lines:41]defaultShipTo:17:=[Customers_Orders:40]defaultShipto:40
[Customers_Order_Lines:41]defaultBillto:23:=[Customers_Orders:40]defaultBillTo:5

If ([Customers_Orders:40]CustID:2=<>sCombindID)  //• 4/20/98 cs users want to combine multiple divisions of same customer 
	
	If ([Customers:16]ID:1#[Estimates_Carton_Specs:19]CustID:6)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Estimates_Carton_Specs:19]CustID:6)
	End if 
	[Customers_Order_Lines:41]CustomerName:24:=[Customers:16]Name:2
	[Customers_Order_Lines:41]SalesRep:34:=[Customers:16]SalesmanID:3
Else 
	[Customers_Order_Lines:41]CustomerName:24:=[Customers_Orders:40]CustomerName:39
	[Customers_Order_Lines:41]SalesRep:34:=[Customers_Orders:40]SalesRep:13
End if 
[Customers_Order_Lines:41]PONumber:21:=[Customers_Orders:40]PONumber:11
[Customers_Order_Lines:41]FOB:36:=[Customers_Orders:40]FOB:25
[Customers_Order_Lines:41]CustomerLine:42:=[Customers_Orders:40]CustomerLine:22  //•060295  MLB  UPR 184
[Customers_Order_Lines:41]ModDate:15:=4D_Current_date
[Customers_Order_Lines:41]ModWho:16:=<>zResp
[Customers_Order_Lines:41]zCount:18:=1
[Customers_Order_Lines:41]ProjectNumber:50:=[Customers_Orders:40]ProjectNumber:53  //•5/04/00  mlb  
//