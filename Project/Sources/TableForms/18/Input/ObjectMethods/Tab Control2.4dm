// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:08:32
// ----------------------------------------------------
// Method: Customer iTabControl
// ----------------------------------------------------
C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControlSub; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Process Spec Overview")
		
	: ($targetPage="Machines & Materials")
		sIntro:=PSpec_DescriptionInText
		
End case 

