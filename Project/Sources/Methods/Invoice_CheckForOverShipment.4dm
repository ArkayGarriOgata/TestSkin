//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 06/13/07, 11:53:29
// ----------------------------------------------------
// Method: Invoice_CheckForOverShipment
// Description
// don't give a credit if original shipment gave cartons for free
// ----------------------------------------------------

C_LONGINT:C283($0; $qtyShippedFree)

$qtyShippedFree:=0

If (Not:C34([Customers:16]Pays_Overship:42))  //don't worry about customers who pay for entire shipment
	QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=$1; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship"; *)
	QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]Location:9="Scrap")
	If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
		$qtyShippedFree:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	End if 
End if 

$0:=$qtyShippedFree