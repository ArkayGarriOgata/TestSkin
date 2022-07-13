//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/03/06, 16:19:30
// ----------------------------------------------------
// Method: Req_setReqNumber
// Description
// ` assign requisition Id number to a new po record
// was [Purchase_Orders]ReqNo:=String(nNextID (8888;1);"R000000")  `assign Requisition number too
// ----------------------------------------------------

C_TEXT:C284($req_id; $0; $server)
C_LONGINT:C283($nextID)

$server:="?"
$nextID:=-3

If (app_getNextID(8888; ->$server; ->$nextID))
	$req_id:="R"+String:C10($nextID; "000000")  //$server+
	
Else 
	$req_id:="-1"
	CANCEL:C270
End if 

$0:=$req_id