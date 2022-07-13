// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:08:32
// ----------------------------------------------------
// Method: Customer iTabControl
// ----------------------------------------------------
C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControl; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Estimate Setup")
		
	: ($targetPage="Differentials")
		ORDER BY:C49([Estimates_Differentials:38]; [Estimates_Differentials:38]diffNum:3; >)
		
		
End case 

