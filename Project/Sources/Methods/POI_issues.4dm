//%attributes = {"publishedWeb":true}
//PM: POI_issues({poitemke}y) -> 
//@author mlb - 9/7/01  10:08

C_LONGINT:C283($0)
C_TEXT:C284($1; $poitem)

$0:=0
If (Count parameters:C259=1)
	$poitem:=$1
Else 
	$poitem:=[Purchase_Orders_Items:12]POItemKey:1
End if 

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$poitem; *)
QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="issue")
If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	$0:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)*-1
End if 