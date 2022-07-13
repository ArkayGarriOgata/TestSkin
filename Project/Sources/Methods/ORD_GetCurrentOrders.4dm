//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/24/10, 13:49:23
// ----------------------------------------------------
// Method: ORD_GetCurrentOrders(productcode;cutoffdate)->num orderline records
// Description
// need this in the CUSTPORT_Export so that button can be en/dis abled depending on whether there are any orders to view
// ----------------------------------------------------

C_TEXT:C284($1)
C_DATE:C307($2)
C_LONGINT:C283($0)

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$1; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"kill@"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13>=$2)

$0:=Records in selection:C76([Customers_Order_Lines:41])