//%attributes = {}
// ----------------------------------------------------
// Method: _version210922
// By: Garri Ogata
// Description:  this is to change the terms for Debra M.
// ----------------------------------------------------
// Date and time: 09/22/21, 14:42:30

C_COLLECTION:C1488($cCustID)

$cCustID:=New collection:C1472()

$cCustID.push("00015")  //Aramis (8)
$cCustID.push("01467")  //Beauty Bank (0)
$cCustID.push("01780")  //Bobbi Brown (0)
$cCustID.push("01382")  //Bumble and Bumble (1)
$cCustID.push("00050")  //Clinique (315)
$cCustID.push("02068")  //Glamglow (0)
$cCustID.push("00121")  //Len Ron  (126)
$cCustID.push("01039")  //Mac (20)
$cCustID.push("01401")  //Origins (0)
$cCustID.push("00152")  //Prescriptives (0)
$cCustID.push("01860")  //Smashbox (1)

READ WRITE:C146([Customers_Orders:40])

For each ($tCustID; $cCustID)
	
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]CustID:2=$tCustID; *)
	QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]Status:10="Accepted"; *)
	QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]ModDate:9>=!2021-01-01!; *)
	QUERY:C277([Customers_Orders:40];  & ; [Customers_Order_Lines:41]Qty_Shipped:10=0; *)
	QUERY:C277([Customers_Orders:40];  & ; [Customers_Order_Lines:41]Qty_Open:11>=0)
	
	APPLY TO SELECTION:C70([Customers_Orders:40]; [Customers_Orders:40]Terms:23:="Net 60")
	
End for each 

READ ONLY:C145([Customers_Orders:40])

ALERT:C41("Terms completed!")
