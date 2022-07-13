//%attributes = {}
// Method: OL_findOpenMatch () -> 
// ----------------------------------------------------
// by: mel: 06/15/05, 12:40:56
// ----------------------------------------------------
// Description:
// attempt to match new PnG release to existing orderline
// ----------------------------------------------------

C_TEXT:C284($0; $1)

$0:="00000.00"

If (Count parameters:C259=1)  //original code
	READ ONLY:C145([Customers_Order_Lines:41])
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=$1)
	$numOrdLines:=qryOpenOrdLines("C"; "C")
	ARRAY TEXT:C222(aOrderLine; 0)
	ARRAY TEXT:C222(aPONum; 0)
	ARRAY LONGINT:C221(accQty; 0)
	ARRAY BOOLEAN:C223(ListBox3; 0)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; aOrderLine; [Customers_Order_Lines:41]PONumber:21; aPONum; [Customers_Order_Lines:41]Qty_Open:11; accQty)
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	SORT ARRAY:C229(aOrderLine; aPONum; accQty; <)
	ARRAY BOOLEAN:C223(ListBox3; $numOrdLines)
	If ($numOrdLines>0)
		ListBox3{1}:=True:C214
		$0:=aOrderLine{1}
	End if 
	//$openOrders:=Sum([Customers_Order_Lines]Qty_Open)
	
Else   //use the the existing array on the dialog
	If (Size of array:C274(aOrderLine)>0)
		If (ListBox3=0)  //grab the newest
			$0:=aOrderLine{1}
		Else   //use the selected orderline
			$0:=aOrderLine{ListBox3}
		End if 
	End if 
End if 

aOrderLine{0}:=$0