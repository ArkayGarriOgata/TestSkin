//%attributes = {"publishedWeb":true}
//gRelSchDel:

If (([Customers_ReleaseSchedules:46]InvoiceNumber:9=0) & ([Customers_ReleaseSchedules:46]B_O_L_number:17=0) & ([Customers_ReleaseSchedules:46]Actual_Qty:8=0))
	$ordline:=[Customers_ReleaseSchedules:46]OrderLine:4
	gDeleteRecord(->[Customers_ReleaseSchedules:46])
	If ([Customers_Order_Lines:41]OrderLine:3#$ordline)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$ordline)
	End if 
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
	[Customers_Order_Lines:41]Qty_Shipped:10:=Sum:C1([Customers_ReleaseSchedules:46]Actual_Qty:8)
	[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]Qty_Shipped:10
	[Customers_Order_Lines:41]QtyWithRel:20:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
	
Else 
	BEEP:C151
	ALERT:C41("Can't delete a release with either an Invoice or Bill of Lading.")
End if 