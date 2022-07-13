//%attributes = {"publishedWeb":true}
//PM: FG_PrepAddCharges([FG_Specification]ControlNumber) -> 
//@author mlb - 7/5/01  12:02

C_TEXT:C284($controlNumber; $1)
C_LONGINT:C283($0)

$controlNumber:=$1
$0:=-1

READ ONLY:C145([Prep_CatalogItems:102])
ALL RECORDS:C47([Prep_CatalogItems:102])
SELECTION TO ARRAY:C260([Prep_CatalogItems:102]ItemNumber:1; $aItems; [Prep_CatalogItems:102]SortOrder:5; $aSortOrder)
REDUCE SELECTION:C351([Prep_CatalogItems:102]; 0)
SORT ARRAY:C229($aSortOrder; $aItems; >)

For ($i; 1; Size of array:C274($aItems))
	CREATE RECORD:C68([Prep_Charges:103])
	[Prep_Charges:103]ControlNumber:1:=$controlNumber
	[Prep_Charges:103]PrepItemNumber:4:=$aItems{$i}
	[Prep_Charges:103]SortOrder:12:=$aSortOrder{$i}
	[Prep_Charges:103]RequestSeries:13:=Num:C11([Finished_Goods_Specifications:98]ServiceRequested:54)
	SAVE RECORD:C53([Prep_Charges:103])
End for 
REDUCE SELECTION:C351([Prep_Charges:103]; 0)

$0:=Size of array:C274($aItems)