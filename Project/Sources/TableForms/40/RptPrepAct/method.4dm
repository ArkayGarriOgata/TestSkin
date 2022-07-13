//(LP) [CustomerOrder]'RptPrepAct
Case of 
	: (Form event code:C388=On Header:K2:17)
		QUERY:C277([Salesmen:32]; [Salesmen:32]ID:1=[Customers_Orders:40]SalesRep:13)
		sSalesman:=[Salesmen:32]LastName:2
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Orders:40]CustID:2)
		xcustName:=[Customers:16]Name:2
	: (Form event code:C388=On Display Detail:K2:22)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Orders:40]CustID:2)
		xcustName:=[Customers:16]Name:2
		If ([Customers_Orders:40]OrderSalesTotal:19>0)
			sSalesValue:=String:C10([Customers_Orders:40]OrderSalesTotal:19; "$###,###,###.00")
		Else 
			sSalesValue:="NEED SV"
		End if 
		If ([Customers_Orders:40]PONumber:11="")
			[Customers_Orders:40]PONumber:11:="NEED PO"
		End if 
		If ([Customers_Orders:40]Comments:15="")
			[Customers_Orders:40]Comments:15:=" "
		End if 
End case 
//EOLP
