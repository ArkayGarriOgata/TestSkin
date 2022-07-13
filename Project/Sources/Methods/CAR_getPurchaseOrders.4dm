//%attributes = {"publishedWeb":true}
//PM: CAR_getPurchaseOrders(cpn) -> 
//@author mlb - 7/19/01  14:39

C_TEXT:C284($cpn; $1)
C_LONGINT:C283($i; $numOL)
ARRAY TEXT:C222(aPO; 0)

$cpn:=$1

READ ONLY:C145([Customers_Order_Lines:41])

If (Length:C16($cpn)>0)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$cpn; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Shipped:10>0)
	DISTINCT VALUES:C339([Customers_Order_Lines:41]PONumber:21; aPO)
End if 

REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)