//(s) t12 ([fg]inventoryreport)
READ ONLY:C145([Estimates_Carton_Specs:19])
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]CartonSpecKey:7=[Customers_Order_Lines:41]CartonSpecKey:19)
If ([Estimates_Carton_Specs:19]OrderType:8="promo@")
	t12:="Promo"
Else 
	t12:=""
End if 
//eos