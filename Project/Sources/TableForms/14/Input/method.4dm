
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeCID
		
	: (Form event code:C388=On Validate:K2:3)
		uUpdateTrail(->[Purchase_Orders_Clauses:14]ModDate:8; ->[Purchase_Orders_Clauses:14]ModWho:9; ->[Purchase_Orders_Clauses:14]zCount:7)
		<>fLoadClaus:=True:C214  //a change was made, indicate need to re-load array
End case 
//
