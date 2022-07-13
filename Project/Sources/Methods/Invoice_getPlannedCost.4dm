//%attributes = {"publishedWeb":true}
//PM: Invoice_getPlannedCost(orderline;release#) -> 
//@author mlb - 6/20/01  09:33
C_LONGINT:C283($i)
C_REAL:C285($0; $cost; $uom)
$cost:=0

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=($1+"/"+String:C10($2)))  //[Bills_of_Lading]Manifest'Arkay_Release)))
SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Jobit:31; $aJobit; [Finished_Goods_Transactions:33]Qty:6; $aQty)
For ($i; 1; Records in selection:C76([Finished_Goods_Transactions:33]))
	If ([Customers_Order_Lines:41]OrderLine:3#$1)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$1)
	End if 
	If ([Customers_Order_Lines:41]SpecialBilling:37)
		$uom:=1
	Else 
		$uom:=1000
	End if 
	$cost:=$cost+(JMI_getJobItPlannedCost($aJobit{$i})*($aQty{$i}/$uom))
End for 

$0:=$cost
//