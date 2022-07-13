//%attributes = {}
// Method: Invoice_getQuantityofOld (orderline;release#;invoiceDATE) -> qty over nine months
// ----------------------------------------------------
// by: mel: 08/11/05, 16:07:19
// ----------------------------------------------------
// Description:
// 
// Modified by: Mel Bohince (12/4/20) use invoice date instead of current date for the cutoff, param 3 added
// ----------------------------------------------------
C_LONGINT:C283($i; $qtyOld; $0)
$qtyOld:=0
C_DATE:C307($glued; $cutoff)
$cutoff:=Add to date:C393($3; 0; -9; 0)

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=($1+"/"+String:C10($2)))  //[Bills_of_Lading]Manifest'Arkay_Release)))
SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]Jobit:31; $aJobit; [Finished_Goods_Transactions:33]Qty:6; $aQty)
For ($i; 1; Size of array:C274($aJobit))
	$glued:=JMI_getGlueDate($aJobit{$i})
	If ($glued#!00-00-00!)
		If ($glued<$cutoff)
			$qtyOld:=$qtyOld+$aQty{$i}
		End if 
	End if 
End for 

$0:=$qtyOld
//
