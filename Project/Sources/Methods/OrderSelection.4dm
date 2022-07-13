//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/21/13, 09:33:01
// ----------------------------------------------------
// Method: OrderSelection
// ----------------------------------------------------

//correct bug last release 03-28-2019 
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=atOrderLine{abOrderLinesLB})
CREATE SET:C116([Customers_Order_Lines:41]; "clickedIncludeRecord")


app_OpenDoubleClickedRecord(->[Customers_Order_Lines:41]; iMode)