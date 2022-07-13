//%attributes = {"publishedWeb":true}
//JOB_CalcNetProduced(jobit)->netQty
// Modified by: Mel Bohince (8/21/13) don't add in adjustments on line 30
// Modified by: Mel Bohince (8/27/20) rtn 0 not -1 so job gets updated when skids were deleted
C_TEXT:C284($1)
C_LONGINT:C283($0; $netQty; $glued; $scrapped; $adjustment)

$netQty:=0
$glued:=0
$scrapped:=0
$adjustment:=0

If (Count parameters:C259=1)
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$1)
Else 
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=[Job_Forms_Items:44]Jobit:4)
End if 

If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
	SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionType:2; $aTransType; [Finished_Goods_Transactions:33]Qty:6; $aTransQty)
	For ($trans; 1; Size of array:C274($aTransType))
		Case of 
			: ($aTransType{$trans}="Receipt")
				$glued:=$glued+$aTransQty{$trans}
			: ($aTransType{$trans}="Scrap")
				$scrapped:=$scrapped+$aTransQty{$trans}
			: ($aTransType{$trans}="Adjust")
				$adjustment:=$adjustment+$aTransQty{$trans}
		End case 
	End for 
	
	$netQty:=$glued-$scrapped  //+$adjustment
	If ($netQty>0)
		$0:=$netQty
	Else   //negative good count
		$0:=0
	End if 
	
Else   //no transactions
	// Modified by: Mel Bohince (8/27/20) rtn 0 not -1 so job gets updated when skids were deleted
	$0:=0
End if 