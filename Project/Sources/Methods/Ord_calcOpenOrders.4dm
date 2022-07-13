//%attributes = {}
//OBSOLETE, see Cust_getOpenOrderTotal
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/21/06, 10:51:06
// ----------------------------------------------------
// Method: Ord_calcOpenOrders
// Description
// find the value of the open orders for a customer
//
// Parameters custid
// ----------------------------------------------------

C_TEXT:C284($1)
C_REAL:C285($0; $booked)
C_LONGINT:C283($order; $qty)

$booked:=0

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Closed"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Rejected"; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]CustID:4=$1)

If (Records in selection:C76([Customers_Order_Lines:41])>0)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Qty_Open:11; $aQty; [Customers_Order_Lines:41]Price_Per_M:8; $aUnitPrice; [Customers_Order_Lines:41]SpecialBilling:37; $aSplBill)
	
	For ($order; 1; Size of array:C274($aQty))
		If ($aSplBill{$order})
			$qty:=$aQty{$order}
		Else 
			$qty:=$aQty{$order}/1000
		End if 
		$booked:=$booked+($qty*$aUnitPrice{$order})
	End for 
	
End if 

$0:=Round:C94($booked; 0)