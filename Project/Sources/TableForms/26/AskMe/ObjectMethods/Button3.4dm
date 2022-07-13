If (Records in set:C195("Customers_Order_Line")=1)
	CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "beforeOrdOpen")
	USE SET:C118("Customers_Order_Line")
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
	ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
	USE NAMED SELECTION:C332("beforeOrdOpen")
	
Else 
	uConfirm("Select an Order Line to see its Releases."; "OK"; "Help")
End if 