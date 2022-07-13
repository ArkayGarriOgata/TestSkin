//%attributes = {}
// -------
// Method: Batch_SetCustOpenOrders   ( ) ->
// By: Mel Bohince @ 09/08/16, 14:25:32
// Description
// set [Customers]Open_Orders daily on active customers, see also Batch_CustomerFinancialStatus
// ----------------------------------------------------

READ WRITE:C146([Customers:16])
QUERY:C277([Customers:16]; [Customers:16]Active:15=True:C214)

While (Not:C34(End selection:C36([Customers:16])))
	$before:=[Customers:16]Open_Orders:34
	$after:=Cust_getOpenOrderTotal([Customers:16]ID:1)
	If ($before#$after)
		[Customers:16]Open_Orders:34:=$after
		SAVE RECORD:C53([Customers:16])
	End if 
	
	NEXT RECORD:C51([Customers:16])
End while 

REDUCE SELECTION:C351([Customers:16]; 0)  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
