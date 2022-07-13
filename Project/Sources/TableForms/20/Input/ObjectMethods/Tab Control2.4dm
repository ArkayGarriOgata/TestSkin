// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:08:32
// ----------------------------------------------------
// Method: Customer iTabControl
// ----------------------------------------------------

C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)

GET LIST ITEM:C378(iInvoiceTabs; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Machine Operations")
		
	: ($targetPage="Subform Details")
		If ([Estimates_Machines:20]FormChangeHere:9)  //3/15/95 upr 66  
			//qryEstSubForm 
		Else 
			uConfirm("No Form Change set for this operation."; "OK"; "Help")
		End if 
		
End case 