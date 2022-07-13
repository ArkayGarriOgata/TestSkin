//(lp) RequisitionForm
//• 6/10/97 cs created
Case of 
	: (Form event code:C388=On Header:K2:17)
		t1:=""  //insure that the var used for code execution does not print
	: (Form event code:C388=On Load:K2:1)  //get items to sort
		RELATE MANY:C262([Purchase_Orders:11]PONo:1)
		ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1; >)
End case 