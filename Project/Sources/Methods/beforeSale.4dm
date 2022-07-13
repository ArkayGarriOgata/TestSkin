//%attributes = {"publishedWeb":true}
//(P) beforeSale: before phase processing for [SALESMAN]

If (Is new record:C668([Salesmen:32]))
	[Salesmen:32]zCount:15:=1
	[Salesmen:32]Active:12:=True:C214
	OBJECT SET ENABLED:C1123(bValidate; False:C215)
	READ ONLY:C145([Users:5])
End if 
If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
	
	READ ONLY:C145([Customers:16])
	QUERY:C277([Customers:16]; [Customers:16]SalesmanID:3=[Salesmen:32]ID:1)
	SELECTION TO ARRAY:C260([Customers:16]ID:1; $aCustID)
	REDUCE SELECTION:C351([Customers:16]; 0)
	
	READ ONLY:C145([Customers_Bookings:93])
	QUERY WITH ARRAY:C644([Customers_Bookings:93]Custid:1; $aCustID)
	
Else 
	
	READ ONLY:C145([Customers_Bookings:93])
	QUERY:C277([Customers_Bookings:93]; [Customers:16]SalesmanID:3=[Salesmen:32]ID:1)
	
End if   // END 4D Professional Services : January 2019 
ORDER BY:C49([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2; <; [Customers_Bookings:93]BookedYTD:3; <)

OBJECT SET ENABLED:C1123(bDelete; False:C215)