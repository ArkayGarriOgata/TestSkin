//%attributes = {"publishedWeb":true}
//(p) rBacklogRpt moved from mthendsuite
//SEARCH([OrderLines];[OrderLines]Qty_Open>0)

qryOpenOrdLines

ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SalesRep:34; >; [Customers_Order_Lines:41]CustomerName:24; >)
BREAK LEVEL:C302(2)
ACCUMULATE:C303([Customers_Order_Lines:41]zCount:18; real1; real2; real3; real4; real5; real6; real7)
util_PAGE_SETUP(->[Customers_Order_Lines:41]; "SalesBacklog")
FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "SalesBacklog")
t2:="SALES AND PRODUCTION BACKLOG"
t2b:="AS OF "+String:C10(dDateEnd; 1)
t3:=""
PDF_setUp(<>pdfFileName)
PRINT SELECTION:C60([Customers_Order_Lines:41]; *)
FORM SET OUTPUT:C54([Customers_Order_Lines:41]; "List")