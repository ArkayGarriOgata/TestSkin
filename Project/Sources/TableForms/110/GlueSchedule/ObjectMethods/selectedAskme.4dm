//(s) bAskMe
//upr 1213

If (aGlueListBox>0)
	<>AskMeFG:=aCPN{aGlueListBox}
	<>AskMeCust:=""  //[CustomerOrder]CustID
	displayAskMe("New")
	
Else 
	uConfirm("You Must a row first."; "OK"; "Help")
End if 