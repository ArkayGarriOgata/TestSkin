//2/2/95
If ([Salesmen:32]ID:1#[Customers_Order_Lines:41]SalesRep:34)
	QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=[Customers_Orders:40]SalesRep:13)
End if 
If (Records in selection:C76([Salesmen:32])>0)  //2/2/95
	t3a:=[Salesmen:32]FirstName:3+"  "+[Salesmen:32]MI:4+"  "+[Salesmen:32]LastName:2
Else 
	t3a:="Salesman Record not found for initials: "+[Customers_Orders:40]SalesRep:13+"!"
End if 
//