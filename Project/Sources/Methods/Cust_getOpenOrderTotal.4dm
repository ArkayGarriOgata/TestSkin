//%attributes = {}
// -------
// Method: Cust_getOpenOrderTotal   ( ) ->
// By: Mel Bohince @ 09/08/16, 13:57:23
// Description
// batch this calc instead of realtime on saving orders and change orders
// ----------------------------------------------------

C_LONGINT:C283($i; $numElements; $total)
$total:=0
ARRAY REAL:C219($aPrice; 0)
ARRAY LONGINT:C221($aOpenQty; 0)
ARRAY BOOLEAN:C223($aSplBill; 0)

If (Count parameters:C259=1)
	$custid:=$1
	ok:=1
Else 
	$custid:=Request:C163("Custid?"; "00050"; "Ok"; "Cancel")
End if 

If (ok=1)
	Begin SQL
		SELECT Price_Per_M, Qty_Open, SpecialBilling
		from Customers_Order_Lines
		where CustID = :$custid and
		Qty_Open > 0 and
		UPPER(Status) not in ('CLOSED', 'CANCEL', 'CANCELLED', 'KILL', 'NEW', 'CONTRACT', 'OPENED', 'CREDIT HOLD', 'HOLD', 'REJECTED')
		into :$aPrice, :$aOpenQty, :$aSplBill
	End SQL
	
	
	$numElements:=Size of array:C274($aPrice)
	
	uThermoInit($numElements; "Calculating Open Order Dollars...")
	For ($i; 1; $numElements)
		If ($aSplBill{$i})
			$total:=$total+Round:C94(($aOpenQty{$i}*$aPrice{$i}); 0)
		Else 
			$total:=$total+Round:C94(($aOpenQty{$i}/1000*$aPrice{$i}); 0)
		End if 
		uThermoUpdate($i)
	End for 
	uThermoClose
End if 

$0:=$total
