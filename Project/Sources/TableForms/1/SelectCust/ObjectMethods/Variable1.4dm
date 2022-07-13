//(s) sCust
READ ONLY:C145([Customers:16])
QUERY:C277([Customers:16]; [Customers:16]ID:1=Self:C308->)
Case of 
	: (Records in selection:C76([Customers:16])=1)
		sCustName:=[Customers:16]Name:2
	: (Records in selection:C76([Customers:16])>1)
		sCustName:="SEVERAL CUSTOMERS SELECTED"
	Else 
		sCustName:=""
End case 
//eos