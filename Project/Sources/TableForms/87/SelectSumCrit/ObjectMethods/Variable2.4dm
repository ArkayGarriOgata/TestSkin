//Script: puCustomers
//040596

Case of 
	: (puCustomers>0)
		QUERY:C277([Job_Forms_CloseoutSummaries:87]; [Job_Forms_CloseoutSummaries:87]Customer:2=puCustomers{Self:C308->})
		DISTINCT VALUES:C339([Job_Forms_CloseoutSummaries:87]Line:3; puLines)
		INSERT IN ARRAY:C227(puLines; 1)
		puLines{1}:="All Lines"
		puLines:=1
		srb1:=1
		srb2:=0
		srb3:=0
		OBJECT SET ENABLED:C1123(srb1; True:C214)
End case 