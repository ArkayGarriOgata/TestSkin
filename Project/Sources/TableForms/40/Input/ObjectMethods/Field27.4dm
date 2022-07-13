//Script: PONumber()  062695  MLB
//•062695  MLB  UPR 202
PO_POnumberFilter(Self:C308)

uConfirm("Apply PO Nº: '"+[Customers_Orders:40]PONumber:11+"' to all order lines?"; "Apply to all"; "No")
If (ok=1)
	APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]PONumber:21:=[Customers_Orders:40]PONumber:11)
End if 
//