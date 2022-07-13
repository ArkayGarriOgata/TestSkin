//%attributes = {"publishedWeb":true}
//gCustAddrDel:

QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustAddrID:2=[Addresses:30]ID:1)
If (Records in selection:C76([Customers_Addresses:31])>0)
	ALERT:C41("Address "+[Addresses:30]ID:1+" is used by customer "+[Customers_Addresses:31]CustID:1+". Must (un)link before before you can delete.")
Else 
	gDeleteRecord(->[Addresses:30])
End if 