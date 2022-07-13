//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 11/09/10, 15:28:47
// ----------------------------------------------------
// Method: PO_ClauseAdd(clauseID;->sequence)
// Description
// assume po record is current
// ----------------------------------------------------

QUERY:C277([Purchase_Orders_Clauses:14]; [Purchase_Orders_Clauses:14]ID:1=$1)
If (Records in selection:C76([Purchase_Orders_Clauses:14])=1)
	CREATE RECORD:C68([Purchase_Orders_PO_Clauses:165])
	[Purchase_Orders_PO_Clauses:165]id_added_by_converter:7:=[Purchase_Orders:11]PO_Clauses:33
	[Purchase_Orders_PO_Clauses:165]ClauseID:2:=[Purchase_Orders_Clauses:14]ID:1
	[Purchase_Orders_PO_Clauses:165]ClauseText:4:=[Purchase_Orders_Clauses:14]ClauseText:3
	[Purchase_Orders_PO_Clauses:165]ClauseTitle:3:=[Purchase_Orders_Clauses:14]Title:2
	[Purchase_Orders_PO_Clauses:165]ParmEntered:6:=False:C215
	[Purchase_Orders_PO_Clauses:165]ParmReqd:5:=[Purchase_Orders_Clauses:14]ParmReqd:4
	If ([Purchase_Orders_PO_Clauses:165]ParmReqd:5)
		$parameters_required:=True:C214
	End if 
	[Purchase_Orders_PO_Clauses:165]SeqNo:1:=$2->
	$2->:=$2->+1
	SAVE RECORD:C53([Purchase_Orders_PO_Clauses:165])
End if 