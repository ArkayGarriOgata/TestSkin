//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 01/15/13, 09:36:43
// ----------------------------------------------------
// Method: ORD_getCostPerM
// ----------------------------------------------------

C_TEXT:C284($1)
C_REAL:C285($0)

If ([Customers_Order_Lines:41]OrderLine:3#$1)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$1)
End if 

If (Records in selection:C76([Customers_Order_Lines:41])>0)
	$0:=[Customers_Order_Lines:41]Cost_Per_M:7
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
Else 
	$0:=0
End if 