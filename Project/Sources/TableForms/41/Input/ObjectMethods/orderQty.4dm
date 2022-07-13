
C_OBJECT:C1216($dollar_o)  // Modified by: Mel Bohince (11/17/21) 
$dollar_o:=OL_ExtendPriceAndCost
If (Abs:C99($dollar_o.extendedPrice)>500000) | (Abs:C99($dollar_o.extendedCost)>500000)
	uConfirm("Price="+String:C10($dollar_o.extendedPrice)+" and cost="+String:C10($dollar_o.extendedCost)+" exceed limit of +/-$500k!"; "Fix"; "Allow")
	If (ok=1)
		[Customers_Order_Lines:41]Quantity:6:=Old:C35([Customers_Order_Lines:41]Quantity:6)
		GOTO OBJECT:C206([Customers_Order_Lines:41]Quantity:6)
	End if 
End if 

[Customers_Order_Lines:41]chgd_qty:28:=True:C214
RELATE MANY:C262([Customers_Order_Lines:41]OrderLine:3)
[Customers_Order_Lines:41]Qty_Shipped:10:=Sum:C1([Customers_ReleaseSchedules:46]Actual_Qty:8)
[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]Qty_Shipped:10
[Customers_Order_Lines:41]QtyWithRel:20:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
// Modified by: Mel Bohince (11/13/15) 
pendingChange:=pendingChange+"Quantity Changed from "+String:C10(Old:C35([Customers_Order_Lines:41]Quantity:6))+" to "+String:C10([Customers_Order_Lines:41]Quantity:6)+Char:C90(Carriage return:K15:38)

//