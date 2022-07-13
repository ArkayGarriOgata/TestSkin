//(lop) DeptEvent
Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Size of array:C274(<>aDeptRptPop)=0)
			ARRAY TEXT:C222(<>aDeptRptPop; 2)
			<>aDeptRptPop{1}:="Expense & Commodity Codes"
			<>aDeptRptPop{2}:="Purchases & hits"
		End if 
End case 
//