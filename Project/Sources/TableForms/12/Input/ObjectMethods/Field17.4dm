If ([Purchase_Orders_Items:12]FixedCost:51)
	
	uConfirm("Unit cost on inventory and transaction will be applied when you save."; "OK"; "Undo")
	If (ok=1)
		[Purchase_Orders_Items:12]UnitPrice:10:=[Purchase_Orders_Items:12]ExtPrice:11/[Purchase_Orders_Items:12]Qty_Received:14
		applyFixedCost:=2
		fNewRM:=True:C214
		CalcPOitem
	Else 
		applyFixedCost:=0
		[Purchase_Orders_Items:12]FixedCost:51:=Old:C35([Purchase_Orders_Items:12]FixedCost:51)
	End if 
	
Else   //try to get unit price back to normal
	uConfirm("Unit cost on inventory and transaction will be appleid when you save."; "OK"; "Undo")
	If (ok=1)
		[Purchase_Orders_Items:12]UnitPrice:10:=[Purchase_Orders_Items:12]ExtPrice:11/(Round:C94([Purchase_Orders_Items:12]Qty_Shipping:4*[Purchase_Orders_Items:12]FactNship2price:25/[Purchase_Orders_Items:12]FactDship2price:38; 3))
		applyFixedCost:=1
		fNewRM:=True:C214
		CalcPOitem
	Else 
		applyFixedCost:=0
		[Purchase_Orders_Items:12]FixedCost:51:=Old:C35([Purchase_Orders_Items:12]FixedCost:51)
	End if 
End if 