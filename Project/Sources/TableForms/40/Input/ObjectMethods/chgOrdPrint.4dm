If (Records in set:C195("clickedIncludeRecordCO")>0)
	CUT NAMED SELECTION:C334([Customers_Order_Change_Orders:34]; "hold")
	USE SET:C118("clickedIncludeRecordCO")
	rRptCustChgOrd
	
	USE NAMED SELECTION:C332("hold")
Else 
	uConfirm("You Must Select a Change Order to Print."; "OK"; "Help")
End if 