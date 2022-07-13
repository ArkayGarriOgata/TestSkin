If (Form event code:C388=On Data Change:K2:15)
	QUERY:C277([Purchase_Orders_Clauses:14]; [Purchase_Orders_Clauses:14]ID:1=[Purchase_Orders_PO_Clauses:165]ClauseID:2)
	If (Records in selection:C76([Purchase_Orders_Clauses:14])=1)
		[Purchase_Orders_PO_Clauses:165]ClauseID:2:=[Purchase_Orders_Clauses:14]ID:1
		[Purchase_Orders_PO_Clauses:165]ClauseText:4:=[Purchase_Orders_Clauses:14]ClauseText:3
		[Purchase_Orders_PO_Clauses:165]ClauseTitle:3:=[Purchase_Orders_Clauses:14]Title:2
		[Purchase_Orders_PO_Clauses:165]ParmEntered:6:=False:C215
		[Purchase_Orders_PO_Clauses:165]ParmReqd:5:=[Purchase_Orders_Clauses:14]ParmReqd:4
		SAVE RECORD:C53([Purchase_Orders_PO_Clauses:165])
		RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)
		ORDER BY:C49([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]SeqNo:1; >)
	Else 
		BEEP:C151
		[Purchase_Orders_PO_Clauses:165]ClauseID:2:=Old:C35([Purchase_Orders_PO_Clauses:165]ClauseID:2)
	End if 
End if 