//%attributes = {"publishedWeb":true}
//PM: Invoice_GetNewNumber() -> 
//@author mlb 

C_TEXT:C284($server)
C_LONGINT:C283($0; $nextID)  //Key No:=fGetInvoiceNum

$server:="?"
$nextID:=No current record:K29:2

If (<>Sync_Activated)
	$success:=app_getNextID(Table:C252(->[Customers_Invoices:88]); ->$server; ->$nextID)
Else 
	$success:=app_getNextID(Table:C252(->[Customers_Invoices:88]); ->$server; ->$nextID)
	//$success:=app_getNextID (9999;->$server;->$nextID)
End if 
If ($nextID=No current record:K29:2)
	$errCode:=TriggerMessage_Set(-31000-Table:C252(->[Customers_Invoices:88]); "[Customers_Invoices] Couldn't get new invoice number")
End if 

$0:=$nextID