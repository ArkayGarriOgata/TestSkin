//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/03/06, 15:33:35
// ----------------------------------------------------
// Method: PO_setPONumber
// Description
// assign an Id number to a new po record
// was [Purchase_Orders]PONo:=String(nNextID (Table(->[Purchase_Orders]));"0000000")
// ----------------------------------------------------

C_TEXT:C284($po_id; $0; $server)
C_LONGINT:C283($nextID)

$server:="?"
$nextID:=-3

If (app_getNextID(Table:C252(->[Purchase_Orders:11]); ->$server; ->$nextID))
	$po_id:=$server+String:C10($nextID; "000000")
	
Else 
	$po_id:="-1"
	CANCEL:C270
End if 

$0:=$po_id