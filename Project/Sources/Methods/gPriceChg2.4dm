//%attributes = {"publishedWeb":true}
//(P) gPriceChg2:   see also gPriceChg
//created for brand change so total orderline amount can be moved to different brn
//$1 longint, denom to use for calcs
//upr 1326 03/09/95 chip
//4/27/95 upr 1252 chip
//• 8/15/97 cs removed booking references

C_REAL:C285(rPriceChg; rQtyChg; rSaleChg; rCostChg; rTTCost; rTTMatlCost; rTTLbrCost; rTTOHCost; rTTScCost)
C_LONGINT:C283($qtyPriced; $qtyCosted; $1; $Denom)

If ([Customers_Order_Lines:41]OrderType:22#"Special Frieght")  //special frieght is NOT to go into ,  upr 1268 chip 02/15/95  
	$Denom:=$1
	$qtyPriced:=[Customers_Order_Lines:41]Quantity:6  //upr 1447 3/6/96
	$qtyCosted:=([Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]ExcessQtySold:40)
	
	rQtyChg:=[Customers_Order_Lines:41]Quantity:6
	lQtyPricedO:=1  //used in gaddtobookings
	rTTCost:=([Customers_Order_Lines:41]Cost_Per_M:7*($qtyCosted/$denom))
	rTTMatlCost:=([Customers_Order_Lines:41]CostMatl_Per_M:32*($qtyCosted/$denom))
	rTTLbrCost:=([Customers_Order_Lines:41]CostLabor_Per_M:30*($qtyCosted/$denom))
	rTTOHCost:=([Customers_Order_Lines:41]CostOH_Per_M:31*($qtyCosted/$denom))
	rTTScCost:=([Customers_Order_Lines:41]CostScrap_Per_M:33*($qtyCosted/$denom))
	rSaleChg:=[Customers_Order_Lines:41]Price_Per_M:8*($qtyPriced/$denom)
End if 