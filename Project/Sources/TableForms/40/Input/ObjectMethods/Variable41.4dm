//(s) Prtorder [customerorder]
//• 3/2/98 cs added save record before printing some data is getting lost
SAVE RECORD:C53([Customers_Orders:40])  //• 3/2/98 cs 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	COPY NAMED SELECTION:C331([Customers_Orders:40]; "RptOrdAckn")
	
	
Else 
	
	ARRAY LONGINT:C221($_RptOrdAckn; 0)
	LONGINT ARRAY FROM SELECTION:C647([Customers_Orders:40]; $_RptOrdAckn)
	
End if   // END 4D Professional Services : January 2019 
ONE RECORD SELECT:C189([Customers_Orders:40])
rRptOrder
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	USE NAMED SELECTION:C332("RptOrdAckn")
	CLEAR NAMED SELECTION:C333("RptOrdAckn")
	
Else 
	
	CREATE SELECTION FROM ARRAY:C640([Customers_Orders:40]; $_RptOrdAckn)
	LOAD RECORD:C52([Customers_Orders:40])  // Added by: Mel Bohince (4/21/19) 
	
End if   // END 4D Professional Services : January 2019 

FORM SET OUTPUT:C54([Customers_Orders:40]; "List")
//
//