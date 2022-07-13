//(S) [VENDOR]'Input(3)'bOpen
//• 8/8/97 cs 
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	qryOpenPOs  // replaced below with this line - consitancy in search algorithims
	
	QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2=[Vendors:7]ID:1)  //made this search selection
	
Else 
	
	<>PassThrough:=True:C214
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved"; *)
	QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Partial@")
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved"; *)
	QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Partial@"; *)
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2=[Vendors:7]ID:1)
	
End if   // END 4D Professional Services : January 2019 query selection

OBJECT SET ENABLED:C1123(bOpen; False:C215)
OBJECT SET ENABLED:C1123(bAll; True:C214)
