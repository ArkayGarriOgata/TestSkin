//%attributes = {}
// ----------------------------------------------------
// Method: RM_PostReceiptPOupdate   ( ) ->
// By: Mel Bohince @ 03/03/16, 15:44:17
// Description
// update the po with the receipt transaction
// ----------------------------------------------------

[Purchase_Orders_Items:12]Qty_Received:14:=Round:C94([Purchase_Orders_Items:12]Qty_Received:14+[Raw_Materials_Transactions:23]Qty:6; 2)  //added round 03/14/95 chip 
[Purchase_Orders_Items:12]Qty_Open:27:=Round:C94([Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14; 2)  //03/14/95 chip
If ([Purchase_Orders_Items:12]Qty_Open:27<0.5) & ([Purchase_Orders_Items:12]Qty_Open:27>-0.5)  //arbitrary value, if the left over is < ±1/2 clear it
	[Purchase_Orders_Items:12]Qty_Open:27:=0
End if 
If ([Purchase_Orders_Items:12]RecvdDate:43=!00-00-00!)  //•5/10/95 dont replace first date
	[Purchase_Orders_Items:12]RecvdDate:43:=[Raw_Materials_Transactions:23]XferDate:3
End if 

[Purchase_Orders_Items:12]RecvdCnt:42:=[Purchase_Orders_Items:12]RecvdCnt:42+1  //5/2/95

SAVE RECORD:C53([Purchase_Orders_Items:12])

