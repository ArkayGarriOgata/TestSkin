//%attributes = {"publishedWeb":true}
//uChgZeroQty
//upr 1303  11/9/94
READ WRITE:C146([Job_Forms_Items:44])
READ WRITE:C146([Customers_ReleaseSchedules:46])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Quantity:6=(Round:C94(0; 4)))
If (Records in selection:C76([Customers_Order_Lines:41])>0)
	RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)
	RELATE MANY SELECTION:C340([Job_Forms_Items:44]OrderItem:2)
	APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2:="Deleted")
	UNLOAD RECORD:C212([Job_Forms_Items:44])
	DELETE SELECTION:C66([Customers_Order_Lines:41])
	DELETE SELECTION:C66([Customers_ReleaseSchedules:46])
End if 
//