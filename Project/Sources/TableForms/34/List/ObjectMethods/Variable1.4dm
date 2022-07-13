//(S) [OrderChgHistory]'List'bprint

If (Records in set:C195("UserSet")#0)
	COPY NAMED SELECTION:C331([Customers_Order_Change_Orders:34]; "CurChg")
	USE SET:C118("UserSet")
	ORDER BY:C49([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]CustID:2; >; [Customers_Order_Change_Orders:34]ChangeOrderNumb:1; >)
	rRptCustChgOrd
	USE NAMED SELECTION:C332("CurChg")
Else 
	ALERT:C41("You Must First Select (highlight) One or More Change Orders to Print")
End if 