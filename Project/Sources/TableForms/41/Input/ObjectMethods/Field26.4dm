
// Modified by: Mel Bohince (11/13/15) 

C_OBJECT:C1216($dollar_o)  // Modified by: Mel Bohince (11/17/21) 
$dollar_o:=OL_ExtendPriceAndCost
If (Abs:C99($dollar_o.extendedPrice)>500000) | (Abs:C99($dollar_o.extendedCost)>500000)
	uConfirm("Price="+String:C10($dollar_o.extendedPrice)+" and cost="+String:C10($dollar_o.extendedCost)+" exceed limit of +/-$500k!"; "Fix"; "Allow")
	If (ok=1)
		[Customers_Order_Lines:41]Cost_Per_M:7:=Old:C35([Customers_Order_Lines:41]Cost_Per_M:7)
		GOTO OBJECT:C206([Customers_Order_Lines:41]Cost_Per_M:7)
	End if 
End if 

pendingChange:=pendingChange+"Price Changed from "+String:C10(Old:C35([Customers_Order_Lines:41]Cost_Per_M:7))+" to "+String:C10([Customers_Order_Lines:41]Cost_Per_M:7)+Char:C90(Carriage return:K15:38)

//