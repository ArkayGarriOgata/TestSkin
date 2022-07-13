//%attributes = {}
// -------
// Method: JMI_getReceipts   ( ) ->
// By: Mel Bohince @ 09/30/16, 06:44:15
// Description
// sum the fg receipt transaction for a jobit
// ----------------------------------------------------

C_LONGINT:C283($0; $qty)
C_TEXT:C284($1)

$qty:=0
If (Count parameters:C259=1)
	$jobit:=$1
Else 
	$jobit:=[Job_Forms_Items:44]Jobit:4
End if 

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$jobit; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]ActionTaken:27="@scan@")

If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
	$qty:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
End if 

$0:=$qty
