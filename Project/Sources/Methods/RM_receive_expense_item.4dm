//%attributes = {}
// ----------------------------------------------------
// Method: RM_receive_expense_item   ( ) -> success
// By: Mel Bohince @ 03/02/16, 14:02:59
// Description
// create a transaction only
// ----------------------------------------------------

C_BOOLEAN:C305($0)
$0:=True:C214

[Raw_Materials_Transactions:23]Reason:5:=[Raw_Materials_Transactions:23]Reason:5+" expense item"
SAVE RECORD:C53([Raw_Materials_Transactions:23])

RM_PostReceiptPOupdate
