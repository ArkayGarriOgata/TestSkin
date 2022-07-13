//%attributes = {"publishedWeb":true}
//PM: ORD_getPricePerM(orderline) -> real
//@author mlb - 5/8/02  15:20

C_TEXT:C284($1)
C_REAL:C285($0)

If ([Customers_Order_Lines:41]OrderLine:3#$1)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$1)
End if 

If (Records in selection:C76([Customers_Order_Lines:41])>0)
	$0:=[Customers_Order_Lines:41]Price_Per_M:8
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
Else 
	$0:=0
End if 