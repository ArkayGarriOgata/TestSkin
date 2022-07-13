//[fg]askme.b1Edit (s) (orderline quadrant)

If (Records in set:C195("Customers_Order_Line")>0)
	COPY SET:C600("Customers_Order_Line"; "◊PassThroughSet")
	<>PassThrough:=True:C214
	ViewSetter(2; ->[Customers_Order_Lines:41])
Else 
	BEEP:C151
End if 
