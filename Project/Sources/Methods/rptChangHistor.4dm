//%attributes = {"publishedWeb":true}
//Procedure: rptChangeHistor()  030398  MLB
//print a log of the changes a customer has made

READ ONLY:C145([Customers_Order_Change_Orders:34])
READ ONLY:C145([Customers_Orders:40])

dDate:=4D_Current_date
iPage:=0

FORM SET OUTPUT:C54([Customers_Order_Change_Orders:34]; "ChangeHistory")
//$cust:=Request("Custid:";"00065")
//$po:=num(Request("order:";"00000"))
//
//SEARCH([OrderChgHistory];[OrderChgHistory]CustID=$cust)  `;*)
//SEARCH([OrderChgHistory]; & [OrderChgHistory]OrderNo=$po)
If (Records in selection:C76([Customers_Order_Change_Orders:34])>0)
	ORDER BY:C49([Customers_Order_Change_Orders:34]; [Customers_Order_Change_Orders:34]OrderNo:5; >)
	BREAK LEVEL:C302(1)
	ACCUMULATE:C303([Customers_Order_Change_Orders:34]zCount:17)
	
	util_PAGE_SETUP(->[Customers_Order_Change_Orders:34]; "ChangeHistory")
	PRINT SELECTION:C60([Customers_Order_Change_Orders:34]; *)
End if 

FORM SET OUTPUT:C54([Customers_Order_Change_Orders:34]; "List")

uClearSelection(->[Customers_Order_Change_Orders:34])
uClearSelection(->[Customers_Orders:40])