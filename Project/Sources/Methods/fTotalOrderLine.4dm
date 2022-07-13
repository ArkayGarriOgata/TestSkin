//%attributes = {"publishedWeb":true}
//(P)fTotalOrderLine mod 3/21/94 upr 1028 , 
//integrate (L)orderline.input save button script
//upr 1447 3/6/95
//4/27/95 chip
//•111398  MLB  UPR use arrays, don't disturb the selection and sort
// Modified by: Mel Bohince (1/16/19) use orderline's extended dollars from trigger calc

C_REAL:C285($0)  //;$thisSale;$totalRev;$totalCost;$totalPrep;$totalProd)
//C_LONGINT($denom)

[Customers_Orders:40]SalePrepTotal:32:=0  //use to be part of the save button on orderline input layout
[Customers_Orders:40]SaleProdTotal:33:=0

If (Records in selection:C76([Customers_Order_Lines:41])>0)
	[Customers_Orders:40]OrderSalesTotal:19:=Sum:C1([Customers_Order_Lines:41]Price_Extended:73)
	[Customers_Orders:40]BudgetCostTotal:20:=Sum:C1([Customers_Order_Lines:41]Cost_Extended:72)
	rTotal1:=Sum:C1([Customers_Order_Lines:41]Quantity:6)
	rTotal2:=Sum:C1([Customers_Order_Lines:41]Qty_Shipped:10)
	rTotal3:=Sum:C1([Customers_Order_Lines:41]Qty_Open:11)
	SAVE RECORD:C53([Customers_Orders:40])
	
Else 
	[Customers_Orders:40]OrderSalesTotal:19:=0
	[Customers_Orders:40]BudgetCostTotal:20:=0  //use to be part of the save button on orderline input layout
	rTotal1:=0
	rTotal2:=0
	rTotal3:=0
End if 

$0:=[Customers_Orders:40]OrderSalesTotal:19
//•111398  MLB  UPR new stuff:
//$totalRev:=0
//$totalCost:=0
//$totalPrep:=0
//$totalProd:=0
//$thisSale:=0

//rTotal1:=0
//rTotal2:=0
//rTotal3:=0
//  //this could be replaced by newer fields sum([Customers_Order_Lines]Price_Extended) and sum([Customers_Order_Lines]Cost_Extended)
//SELECTION TO ARRAY([Customers_Order_Lines]CustID;$aCust;[Customers_Order_Lines]ProductCode;$aCPN;[Customers_Order_Lines]Quantity;$aQty;[Customers_Order_Lines]ExcessQtySold;$aExc;[Customers_Order_Lines]Price_Per_M;$aPrice;[Customers_Order_Lines]Cost_Per_M;$aCost;[Customers_Order_Lines]OrderType;$aisPrep;[Customers_Order_Lines]Qty_Shipped;$aQtyShipped;[Customers_Order_Lines]Qty_Open;$aQtyOpen;[Customers_Order_Lines]Status;$aStatus;[Customers_Order_Lines]SpecialBilling;$aSB)
//i1:=Size of array($aCust)
//For ($i;1;i1)
//If ($aStatus{$i}#"Cancel")
//  // Modified by: Mel Bohince (1/9/19) 
//If ($aSB{$i})  //use Each
//$denom:=1
//Else   // use /M
//$denom:=1000
//End if 
//  //$denom:=nlGetFGDenom ($aCust{$i};$aCPN{$i})//removed Modified by: Mel Bohince (1/9/19) 
//$thisSale:=($aQty{$i}/$denom)*$aPrice{$i}
//$totalRev:=$totalRev+$thisSale
//$totalCost:=$totalCost+(($aQty{$i}-$aExc{$i})/$denom*$aCost{$i})
//If ($aisPrep{$i}="Preparatory")
//$totalPrep:=$totalPrep+$thisSale
//Else 
//$totalProd:=$totalProd+$thisSale
//End if 

//rTotal1:=rTotal1+$aQty{$i}
//rTotal2:=rTotal2+$aQtyShipped{$i}
//rTotal3:=rTotal3+$aQtyOpen{$i}
//End if 
//End for 


//REDUCE SELECTION([Finished_Goods];0)
//
//$0:=$totalRev
//[Customers_Orders]OrderSalesTotal:=$totalRev
//[Customers_Orders]BudgetCostTotal:=$totalCost  //use to be part of the save button on orderline input layout
//[Customers_Orders]SalePrepTotal:=$totalPrep  //use to be part of the save button on orderline input layout
//[Customers_Orders]SaleProdTotal:=$totalProd
//SAVE RECORD([Customers_Orders])

fItemChg:=False:C215
//