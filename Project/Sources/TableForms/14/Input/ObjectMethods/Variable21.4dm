//(s) bAddIncl [po_clasue_table] input.
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		CREATE SET:C116([Purchase_Order_Comm_Clauses:83]; "Current")
		CREATE RECORD:C68([Purchase_Order_Comm_Clauses:83])
		[Purchase_Order_Comm_Clauses:83]Clause:2:=[Purchase_Orders_Clauses:14]ID:1
		SAVE RECORD:C53([Purchase_Order_Comm_Clauses:83])
		ADD TO SET:C119([Purchase_Order_Comm_Clauses:83]; "Current")
		USE SET:C118("Current")
		CLEAR SET:C117("Current")
		ORDER BY:C49([Purchase_Order_Comm_Clauses:83]; [Purchase_Order_Comm_Clauses:83]CommodityCode:1; >)
		
	Else 
		ARRAY LONGINT:C221($_record_number; 0)
		SELECTION TO ARRAY:C260([Purchase_Order_Comm_Clauses:83]; $_record_number)
		CREATE RECORD:C68([Purchase_Order_Comm_Clauses:83])
		[Purchase_Order_Comm_Clauses:83]Clause:2:=[Purchase_Orders_Clauses:14]ID:1
		SAVE RECORD:C53([Purchase_Order_Comm_Clauses:83])
		APPEND TO ARRAY:C911($_record_number; Record number:C243([Purchase_Order_Comm_Clauses:83]))
		CREATE SELECTION FROM ARRAY:C640([Purchase_Order_Comm_Clauses:83]; $_record_number)
		ORDER BY:C49([Purchase_Order_Comm_Clauses:83]; [Purchase_Order_Comm_Clauses:83]CommodityCode:1; >)
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	
	
	
	ARRAY LONGINT:C221($_record_number; 0)
	LONGINT ARRAY FROM SELECTION:C647([Purchase_Order_Comm_Clauses:83]; $_record_number)
	CREATE RECORD:C68([Purchase_Order_Comm_Clauses:83])
	[Purchase_Order_Comm_Clauses:83]Clause:2:=[Purchase_Orders_Clauses:14]ID:1
	SAVE RECORD:C53([Purchase_Order_Comm_Clauses:83])
	APPEND TO ARRAY:C911($_record_number; Record number:C243([Purchase_Order_Comm_Clauses:83]))
	CREATE SELECTION FROM ARRAY:C640([Purchase_Order_Comm_Clauses:83]; $_record_number)
	ORDER BY:C49([Purchase_Order_Comm_Clauses:83]; [Purchase_Order_Comm_Clauses:83]CommodityCode:1; >)
	
	
End if   // END 4D Professional Services : January 2019 
