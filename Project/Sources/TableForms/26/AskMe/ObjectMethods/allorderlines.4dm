
If (allorderlines=0)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=sCPN; *)  //switch to fg_key
	
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=sCustID; *)  //switch to fg_key
	
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //upr 1326 2/14/95 2/15/95
	
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)  //upr 1326 2/14/95
	
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed"; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Rejected")  //`•5/04/99  MLB  UP
	
	
Else 
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=sCPN; *)  //switch to fg_key
	
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=sCustID)  //switch to fg_key  
	
End if 
CREATE SET:C116([Customers_Order_Lines:41]; "oneLoaded")
sAskMeTotals
//