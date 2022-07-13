//%attributes = {"publishedWeb":true}
//PM: POI_inventory() -> 
//@author mlb - 9/7/01  10:12

C_LONGINT:C283($0)
C_TEXT:C284($1; $poitem)

$0:=0
If (Count parameters:C259=1)
	$poitem:=$1
Else 
	$poitem:=[Purchase_Orders_Items:12]POItemKey:1
End if 

QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=$poitem)
If (Records in selection:C76([Raw_Materials_Locations:25])>0)
	$0:=Sum:C1([Raw_Materials_Locations:25]QtyOH:9)
End if 