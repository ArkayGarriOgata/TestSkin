//(s) sType
Case of 
	: ([Purchase_Orders:11]Status:15="Printed") | ([Purchase_Orders:11]Status:15="Faxed") | ([Purchase_Orders:11]ConfirmingOrder:29)
		sType:="Order Confirmation"
	: (Position:C15("CO"; [Purchase_Orders:11]Status:15)>0) | ([Purchase_Orders:11]Status:15="Chg Order")
		sType:="Order Change#: "+[Purchase_Orders:11]LastChgOrdNo:18
	Else 
		sType:="Purchase Order"
End case 


//
