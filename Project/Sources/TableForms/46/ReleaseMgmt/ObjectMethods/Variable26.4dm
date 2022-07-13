//(s) bAskMe
//upr 1213

If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Customers_ReleaseSchedules:46]; "hold")
	USE SET:C118("clickedIncluded")
	
	<>AskMeFG:=[Customers_ReleaseSchedules:46]ProductCode:11
	<>AskMeCust:=""  //[CustomerOrder]CustID
	displayAskMe("New")
	USE NAMED SELECTION:C332("hold")
	HIGHLIGHT RECORDS:C656([Customers_ReleaseSchedules:46]; "clickedIncluded")
	
Else 
	uConfirm("Select a Release first."; "OK"; "Help")
End if 