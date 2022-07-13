//%attributes = {}
//Method:  JbFI_SumQtyWantN(tOrderItem)=>nQtyWant
//Description:  This method will query [Job_Forms_Items]OrderItem and sum [Job_Forms_Items]Qty_Want

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tOrderItem)
	C_LONGINT:C283($0; $nQtyWant)
	
	C_TEXT:C284($tQuery)
	
	$tOrderItem:=$1
	$nQtyWant:=0
	
	$tQuery:=CorektBlank
	
End if   //Done initialize

If ($tOrderItem#CorektBlank)  //Order item
	
	$tQuery:="OrderItem = "+CorektSingleQuote+$tOrderItem+CorektSingleQuote
	
	$nQtyWant:=Core_Query_SumV($tQuery; ->[Job_Forms_Items:44]Qty_Want:24)
	
End if   //Done order item

$0:=$nQtyWant