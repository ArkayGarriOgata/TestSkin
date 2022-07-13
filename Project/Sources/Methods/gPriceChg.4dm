//%attributes = {"publishedWeb":true}
//(P) gPriceChg: 
//$1 longint, denom to use in calcs
//see also gPriceChg2
//upr 1268 chip 02/15/95
//upr 1447 3/6/96
//upr 1326 03/09/95 chip
//  changed local vars to process
//  added procedure gAdjustBookings
//  added call to gaddtobookings
//4/27/95 upr 1252 chip`4/27/9
//• 8/15/97 cs disabled bookings references at Jim B's request

C_LONGINT:C283(lQtyPricedO; lQtyCostedO; lQtyPricedN; lQtyCostedN; $1; $Denom)  //4/27/95
C_REAL:C285(rPriceChg; rQtyChg; rSaleChg; rCostChg; rTTCost; rTTMatlCost; rTTLbrCost; rTTOHCost; rTTScCost)

$Denom:=$1  //4/27/95

lQtyPricedO:=[Customers_Order_Changed_Items:176]OldQty:2  //upr 1447 3/6/96
lQtyCostedO:=([Customers_Order_Changed_Items:176]OldQty:2-[Customers_Order_Changed_Items:176]OldExcessQty:39)
lQtyPricedN:=[Customers_Order_Changed_Items:176]NewQty:4  //upr 1447 3/6/96
lQtyCostedN:=([Customers_Order_Changed_Items:176]NewQty:4-[Customers_Order_Changed_Items:176]NewExcessQty:40)

rQtyChg:=[Customers_Order_Changed_Items:176]NewQty:4-[Customers_Order_Changed_Items:176]OldQty:2
//FIND the DELTAS for qty, price, and cost
rTTCost:=([Customers_Order_Changed_Items:176]NewCost:14*(lQtyCostedN/$denom))-([Customers_Order_Changed_Items:176]OldCost:13*(lQtyCostedO/$denom))
rTTMatlCost:=([Customers_Order_Changed_Items:176]NewMatlCost:17*(lQtyCostedN/$denom))-([Customers_Order_Changed_Items:176]OldMatlCost:16*(lQtyCostedO/$denom))
rTTLbrCost:=([Customers_Order_Changed_Items:176]NewLaborCost:19*(lQtyCostedN/$denom))-([Customers_Order_Changed_Items:176]OldLaborCost:18*(lQtyCostedO/$denom))
rTTOHCost:=([Customers_Order_Changed_Items:176]NewOHCost:21*(lQtyCostedN/$denom))-([Customers_Order_Changed_Items:176]OldOHCost:20*(lQtyCostedO/$denom))
rTTScCost:=([Customers_Order_Changed_Items:176]NewSECost:23*(lQtyCostedN/$denom))-([Customers_Order_Changed_Items:176]OldSECost:22*(lQtyCostedO/$denom))

[Customers_Orders:40]BudgetCostTotal:20:=[Customers_Orders:40]BudgetCostTotal:20+rTTCost

rSaleChg:=([Customers_Order_Changed_Items:176]NewPrice:5*(lQtyPricedN/$denom))-([Customers_Order_Changed_Items:176]OldPrice:3*(lQtyPricedO/$denom))
[Customers_Orders:40]OrderSalesTotal:19:=[Customers_Orders:40]OrderSalesTotal:19+rSaleChg

If ([Customers_Order_Lines:41]OrderType:22="Prep@")  //•072395  MLB  add @
	[Customers_Orders:40]SalePrepTotal:32:=[Customers_Orders:40]SalePrepTotal:32+rSaleChg
	[Customers_Orders:40]BudgetPrepTotal:34:=[Customers_Orders:40]BudgetPrepTotal:34+rTTCost
Else 
	[Customers_Orders:40]SaleProdTotal:33:=[Customers_Orders:40]SaleProdTotal:33+rSaleChg
	[Customers_Orders:40]BudgetProdTotal:35:=[Customers_Orders:40]BudgetProdTotal:35+rTTCost
End if 