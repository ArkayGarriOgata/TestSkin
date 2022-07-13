If (r1#0)
	rQty2:=rQty*r1
	
	If (r2#0)
		rQty2:=rQty2/r2
	End if 
	rPriceConv:=arNum2{aPOPrice}/arDenom2{aPOPrice}  //shipping to billing = ([PO_ITEMS]FactNship2price/[PO_ITEMS]FactDship2price)
	rPriceConv:=rPriceConv*(r2/r1)  //arkay to shipping =([PO_ITEMS]FactNship2cost/[PO_ITEMS]FactDship2cost
	rActPrice:=aPOPrice{aPOPrice}*rPriceConv
	rQty2:=Round:C94(rQty2; 2)
End if 