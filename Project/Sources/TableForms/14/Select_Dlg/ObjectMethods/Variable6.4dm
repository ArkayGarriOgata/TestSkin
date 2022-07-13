//(S) [PO_CLAUSE_TABLE]Select_Dlg'bOK
If (Find in array:C230(<>alClausChk; 1)<1)  //none selected
	uRejectAlert("You did not select any clauses!"+<>sCR+<>sCR+"Try again.")
End if 
//EOS