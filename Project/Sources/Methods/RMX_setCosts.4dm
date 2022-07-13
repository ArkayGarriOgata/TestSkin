//%attributes = {}
// Method: RMX_setCosts (poitemkey;unitcost) -> 
// ----------------------------------------------------
// by: mel: 11/09/04, 11:37:31
// ----------------------------------------------------
// Description:
// set the costs and extensions on rmx's

C_TEXT:C284($1)
C_REAL:C285($2)
CUT NAMED SELECTION:C334([Raw_Materials_Transactions:23]; "beforeFixCost")
READ WRITE:C146([Raw_Materials_Transactions:23])

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$1)
SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Qty:6; $aQty; [Raw_Materials_Transactions:23]UnitPrice:7; $aPrice; [Raw_Materials_Transactions:23]ActCost:9; $aCost; [Raw_Materials_Transactions:23]ActExtCost:10; $aExtend)
For ($i; 1; Size of array:C274($aQty))
	$aPrice{$i}:=$2
	$aCost{$i}:=$aPrice{$i}
	$aExtend{$i}:=Round:C94($aPrice{$i}*$aQty{$i}; 2)
End for 
ARRAY TO SELECTION:C261($aPrice; [Raw_Materials_Transactions:23]UnitPrice:7; $aCost; [Raw_Materials_Transactions:23]ActCost:9; $aExtend; [Raw_Materials_Transactions:23]ActExtCost:10)

USE NAMED SELECTION:C332("beforeFixCost")