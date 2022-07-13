//(s) bAskMe
//upr 1213

If (Records in set:C195("clickedIncludeRecord")>0)
	CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	<>AskMeFG:=[Customers_Order_Lines:41]ProductCode:5
	<>AskMeCust:=""  //[CustomerOrder]CustID
	displayAskMe("New")
	USE NAMED SELECTION:C332("hold")
	
Else 
	uConfirm("You Must Select a Line Item first."; "OK"; "Help")
End if 