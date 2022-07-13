//%attributes = {"publishedWeb":true}
//gVendorDel:

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2=[Vendors:7]ID:1)
If (Records in selection:C76([Purchase_Orders:11])>0)
	ALERT:C41("Vendor is listed in Purchase Order record.  The PO record must be delete first.")
Else 
	gDeleteRecord(->[Vendors:7])
End if 