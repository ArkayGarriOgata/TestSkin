// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:07:56
//PO iTabControl
// ----------------------------------------------------
C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControlSub; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="PO Item Detail")
		
	: ($targetPage="Receipts & Direct Purchase Jobs")
		
	: ($targetPage="Releases")
		
		
End case 

