//%attributes = {"publishedWeb":true}
//JOB_CalcQtyGlued(jobit)->netQty
// Modified by: Mel Bohince (8/27/20) rtn 0 not -1 so job gets updated when skids were deleted
C_TEXT:C284($1)
C_LONGINT:C283($0; $glued)

$glued:=0

If (Count parameters:C259=1)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$1; *)
Else 
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=[Job_Forms_Items:44]Jobit:4; *)
End if 
QUERY:C277([Finished_Goods_Transactions:33];  & [Finished_Goods_Transactions:33]XactionType:2="Receipt")

If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
	$glued:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	
	If ($glued>0)
		$0:=$glued
	Else   //negative good count
		$0:=0
	End if 
	
Else   //no transactions
	// Modified by: Mel Bohince (8/27/20) rtn 0 not -1 so job gets updated when skids were deleted
	$0:=0  //-1
	
End if 