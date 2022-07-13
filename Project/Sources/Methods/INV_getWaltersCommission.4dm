//%attributes = {"publishedWeb":true}
//INV_getWaltersCommission 04/03/02

READ ONLY:C145([Customers_Projects:9])

QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=[Customers_Order_Lines:41]ProjectNumber:50; *)
QUERY:C277([Customers_Projects:9];  & ; [Customers_Projects:9]z_obsolete_ws_date:13>=4D_Current_date)
If (Records in selection:C76([Customers_Projects:9])>0)
	$0:=0.01
Else 
	$0:=0
End if 