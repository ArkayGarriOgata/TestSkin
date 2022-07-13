//%attributes = {"publishedWeb":true}
//gCustomerDel:
//12/6/94 made more better  : )

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]CustID:2=[Customers:16]ID:1)
QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustID:2=[Customers:16]ID:1)

Case of 
	: (Records in selection:C76([Finished_Goods:26])>0)
		ALERT:C41("Customer has Finished Goods.  F/G record must be deleted.")
	: (Records in selection:C76([Customers_Orders:40])>0)
		ALERT:C41("Customer has an Order.  Order record must be deleted.")
	Else 
		$custid:=[Customers:16]ID:1
		gDeleteRecord(->[Customers:16])
		If ((fDelete) & (Not:C34(fCnclTrn)))
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=$custid)
			If (Records in selection:C76([Customers_Contacts:52])>0)
				DELETE SELECTION:C66([Customers_Contacts:52])
			End if 
			
			QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=$custid)
			If (Records in selection:C76([Customers_Brand_Lines:39])>0)
				DELETE SELECTION:C66([Customers_Brand_Lines:39])
			End if 
			
			QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=$custid)
			If (Records in selection:C76([Customers_Addresses:31])>0)
				DELETE SELECTION:C66([Customers_Addresses:31])
			End if 
		End if 
		
End case 