//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/05/13, 16:47:32
// ----------------------------------------------------
// Method: JMI_getPricePerM
// Description
// given a jobit, try to find a price
// ----------------------------------------------------

C_LONGINT:C283($num)
C_REAL:C285($0)
C_TEXT:C284($1)

READ ONLY:C145([Customers_Order_Lines:41])

If ([Job_Forms_Items:44]Jobit:4#$1)
	READ ONLY:C145([Job_Forms_Items:44])
	$num:=qryJMI($1)
End if 

If (Records in selection:C76([Job_Forms_Items:44])>0)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		$0:=[Customers_Order_Lines:41]Price_Per_M:8
	Else 
		$0:=0
	End if 
Else 
	$0:=-1
End if 