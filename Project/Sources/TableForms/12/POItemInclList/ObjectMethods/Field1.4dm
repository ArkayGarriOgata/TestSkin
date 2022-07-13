If ([Purchase_Orders_Items:12]POItemKey:1#([Purchase_Orders_Items:12]PONo:2+[Purchase_Orders_Items:12]ItemNo:3))
	[Purchase_Orders_Items:12]POItemKey:1:=[Purchase_Orders_Items:12]PONo:2+[Purchase_Orders_Items:12]ItemNo:3
	SAVE RECORD:C53([Purchase_Orders_Items:12])
End if 