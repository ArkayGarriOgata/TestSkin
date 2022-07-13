//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/07/07, 13:13:33
// ----------------------------------------------------
// Method: Invoice_getFiFoCost(orderline;release#)->extended fifo cost , see JIC_Relieve in uPostFGxaction
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_REAL:C285($0)

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=($1+"/"+String:C10($2)))  //[Bills_of_Lading]Manifest'Arkay_Release)))
If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
	$0:=Sum:C1([Finished_Goods_Transactions:33]CoGSExtended:8)
Else 
	$0:=0
End if 
//