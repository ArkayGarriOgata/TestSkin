C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)

GET LIST ITEM:C378(iTabControl; *; $itemRef; $targetPage)
Case of 
	: (Form event code:C388=On Load:K2:1)
		//shouldn't be active, don't want the save below to hit before the init of the form's onload event, else chaos
		
	: ($targetPage="Stage")
		bol_manifest_manual_edit:=False:C215
		
	: ($targetPage="Ship")
		If (bol_manifest_refresh_required)
			[Customers_Bills_of_Lading:49]QualityAssur:22:=<>zResp
			BOL_ListBox1("save-to-blob")
			If (bol_manifest_manual_edit)
				uConfirm("Keep edits made to the Printout?"; "Keep"; "Remove")
				If (ok=0)
					bol_manifest_manual_edit:=False:C215
				End if 
			End if 
			BOL_ListBox1("create-manifest")
			
		End if 
		
	: ($targetPage="Printout")
		bol_manifest_manual_edit:=False:C215
End case 