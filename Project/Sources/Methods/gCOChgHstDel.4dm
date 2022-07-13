//%attributes = {"publishedWeb":true}
//gCOChgHstDel: Deletion for Customer Order file [OrderChgHistory]

gDeleteRecord(->[Customers_Order_Change_Orders:34])
If (fCnclTrn=False:C215)
	[Customers_Orders:40]Status:10:="Accepted"
	SAVE RECORD:C53([Customers_Orders:40])
End if 