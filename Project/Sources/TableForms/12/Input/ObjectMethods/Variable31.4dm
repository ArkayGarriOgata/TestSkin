uConfirm("Clear the Shipping and Stocking Quantities?"; "Clear"; "Cancel")
If (ok=1)
	[Purchase_Orders_Items:12]Qty_Shipping:4:=0
	[Purchase_Orders_Items:12]Qty_Ordered:30:=0
	CalcPOitem
End if 