//%attributes = {"publishedWeb":true}
//gSalesmanDel:

READ ONLY:C145([Customers:16])
QUERY:C277([Customers:16]; [Customers:16]SalesmanID:3=[Salesmen:32]ID:1)
If (Records in selection:C76([Customers:16])>0)
	BEEP:C151
	ALERT:C41("Salesman is listed in Customer record.  Customer record must be reassigned first")
Else 
	gDeleteRecord(->[Salesmen:32])
End if 
READ WRITE:C146([Customers:16])