//%attributes = {"publishedWeb":true}
//Procedure: qryOpenPOs()  110795  MLB
//get this out of local porcess
//• 8/8/97 cs new status - Faxed

//QUERY([Purchase_Orders];[Purchase_Orders]Status="Open";*)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved"; *)
	QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Partial@")
	//QUERY([Purchase_Orders]; | ;[Purchase_Orders]Status="@Hold";*)
	//QUERY([Purchase_Orders]; | ;[Purchase_Orders]Status="@Processed";*)
	//QUERY([Purchase_Orders]; | ;[Purchase_Orders]Status="@Printed";*)
	//QUERY([Purchase_Orders]; | ;[Purchase_Orders]Status="Chg Order";*)
	//QUERY([Purchase_Orders]; | ;[Purchase_Orders]Status="@Faxed";*)  `• 8/8/97 cs new status
	//QUERY([Purchase_Orders]; & ;[Purchase_Orders]INX_autoPO=False)
	CREATE SET:C116([Purchase_Orders:11]; "◊PassThroughSet")
Else 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved"; *)
	QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Partial@")
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
End if   // END 4D Professional Services : January 2019 query selection


<>PassThrough:=True:C214