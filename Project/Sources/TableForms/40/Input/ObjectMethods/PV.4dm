//(S)bViewPV: Booking Manager may view PV
//gDisplayPV ("New")
//EOS
$lSale:=Sum:C1([Customers_Order_Lines:41]Price_Extended:73)
$lCost:=Sum:C1([Customers_Order_Lines:41]Cost_Extended:72)
$rebate:=fGetCustRebate([Customers_Order_Lines:41]CustID:4)  //•061998  MLB  
rPVCalc:=fProfitVariable("PV"; $lCost; $lSale; 0; $rebate)  //•061998  MLB  add rebate to pv calc
rPVCalc:=Round:C94(rPVCalc*100; 2)

uConfirm("PV = "+String:C10(rPVCalc)+" with ttl cost of "+String:C10($lCost)+" and ttl price of "+String:C10($lSale); "Ok"; "Help")
