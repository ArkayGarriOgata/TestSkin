//%attributes = {"publishedWeb":true}
//(P) gSelectClaus: presents dialog for user selection of PO Clauses

C_LONGINT:C283($num; $NextSeq; $i; $j)

$winRef:=NewWindow(354; 246; 6; 1; "")

If (<>fLoadClaus)
	MESSAGE:C88(" Loading Clause Table...")
	ALL RECORDS:C47([Purchase_Orders_Clauses:14])
	SELECTION TO ARRAY:C260([Purchase_Orders_Clauses:14]ID:1; <>asClausID; [Purchase_Orders_Clauses:14]Title:2; <>asClausTitl)
	SORT ARRAY:C229(<>asClausID; <>asClausTitl; >)
	ARRAY LONGINT:C221(<>alClausChk; 0)  //clear
	ARRAY LONGINT:C221(<>alClausChk; Size of array:C274(<>asClausTitl))  //set same size as title array
	<>fLoadClaus:=False:C215
	<>lClausNum:=0  //number selected
End if 
DIALOG:C40([Purchase_Orders_Clauses:14]; "Select_Dlg")
If (OK=1)
	RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)
	CREATE SET:C116([Purchase_Orders_PO_Clauses:165]; "existingClauses")
	If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])=0)
		$NextSeq:=1
	Else 
		$NextSeq:=Max:C3([Purchase_Orders_PO_Clauses:165]SeqNo:1)+1
	End if 
	//get selected clauses
	$parameters_required:=False:C215
	For ($i; 1; Size of array:C274(<>alClausChk))
		If (<>alClausChk{$i}=1)  //add the clause
			<>alClausChk{$i}:=0  //clear it for next time
			USE SET:C118("existingClauses")
			QUERY SELECTION:C341([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]ClauseID:2=<>asClausID{$i})
			If (Records in selection:C76([Purchase_Orders_PO_Clauses:165])=0)  //doesn't already exist, so add it
				PO_ClauseAdd(<>asClausID{$i}; ->$NextSeq)
			End if 
		End if 
	End for 
	CLEAR SET:C117("existingClauses")
	
	If ($parameters_required)
		ALERT:C41("Clause Parameters required by at least one of the select, please review them.")
	End if 
End if 

CLOSE WINDOW:C154

RELATE MANY:C262([Purchase_Orders:11]PO_Clauses:33)
ORDER BY:C49([Purchase_Orders_PO_Clauses:165]; [Purchase_Orders_PO_Clauses:165]SeqNo:1; >)