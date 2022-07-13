//%attributes = {"publishedWeb":true}
//rRptPrepAct:

READ ONLY:C145([Customers:16])
ALL RECORDS:C47([Customers_Orders:40])
FORM SET OUTPUT:C54([Customers_Orders:40]; "RptPrepAct")
xReptTitle:="ARKAY PACKAGING CORPORATION"+Char:C90(13)+"PREPARATORY ACTIVITY LOG"
ORDER BY:C49([Customers_Orders:40]; [Customers_Orders:40]SalesRep:13; >; [Customers_Orders:40]CustID:2; >)
BREAK LEVEL:C302(1)
ACCUMULATE:C303([Customers_Orders:40]OrderSalesTotal:19)
util_PAGE_SETUP(->[Customers_Orders:40]; "RptPrepAct")
PRINT SELECTION:C60([Customers_Orders:40])
FORM SET OUTPUT:C54([Customers_Orders:40]; "List")
READ WRITE:C146([Customers:16])