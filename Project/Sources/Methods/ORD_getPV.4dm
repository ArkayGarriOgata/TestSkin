//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 01/15/13, 09:30:52
// ----------------------------------------------------
// Method: ORD_getPV
// ----------------------------------------------------

C_TEXT:C284($1)
C_REAL:C285($0)

If ([Customers_Order_Lines:41]OrderLine:3#$1)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$1)
End if 

If (Records in selection:C76([Customers_Order_Lines:41])>0)
	
	$0:=fProfitVariable("PV"; [Customers_Order_Lines:41]Cost_Per_M:7; [Customers_Order_Lines:41]Price_Per_M:8; 0)
	
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
Else 
	$0:=0
End if 