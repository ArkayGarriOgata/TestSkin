//%attributes = {"publishedWeb":true}
//Procedure: uNewOrderline()  101395  MLB

If ([Customers_Orders:40]Status:10="Open@") | (True:C214)  // & ([CustomerOrder]Status#"Chg Order") & ([CustomerOrder]Status#"Approved")
	[Customers_Order_Lines:41]OrderNumber:1:=[Customers_Orders:40]OrderNumber:1
	i1:=i1+1
	[Customers_Order_Lines:41]LineItem:2:=i1
	[Customers_Order_Lines:41]OrderLine:3:=fMakeOLkey([Customers_Order_Lines:41]OrderNumber:1; [Customers_Order_Lines:41]LineItem:2)  // Modified by: Mel Bohince (2/25/21) 
	//[Customers_Order_Lines]OrderLine:=String([Customers_Order_Lines]OrderNumber;"00000")+"."+String([Customers_Order_Lines]LineItem;"00")
	[Customers_Order_Lines:41]CustID:4:=[Customers_Orders:40]CustID:2
	[Customers_Order_Lines:41]ModDate:15:=4D_Current_date
	[Customers_Order_Lines:41]ModWho:16:=<>zResp
	[Customers_Order_Lines:41]Status:9:="Opened"
	[Customers_Order_Lines:41]PONumber:21:=[Customers_Orders:40]PONumber:11
	[Customers_Order_Lines:41]defaultShipTo:17:=[Customers_Orders:40]defaultShipto:40
	[Customers_Order_Lines:41]defaultBillto:23:=[Customers_Orders:40]defaultBillTo:5
	[Customers_Order_Lines:41]CustomerName:24:=[Customers_Orders:40]CustomerName:39
	If ([Estimates:17]EstimateNo:1#[Customers_Orders:40]EstimateNo:3)
		QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=[Customers_Orders:40]EstimateNo:3)
	End if 
	[Customers_Order_Lines:41]NeedDate:14:=[Customers_Orders:40]NeedDate:51  //[Estimates]DateEstimateNeeded
	
Else 
	uConfirm("Order Line Items cannot be added.  Customer Order Status is at "+[Customers_Orders:40]Status:10+"."; "OK"; "Help")
	CANCEL:C270
End if 