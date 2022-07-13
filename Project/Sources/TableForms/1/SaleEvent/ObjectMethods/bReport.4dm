// ----------------------------------------------------
// Method: [zz_control].SaleEvent.bReport
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:="Salesman Listing;Salesmen Activity Report"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					ViewSetter(7; ->[Salesmen:32]; "Salesman Listing")
					
				: ($user_choice=2)
					$pid:=New process:C317("Pjt_SalesmenActivity"; <>lMidMemPart; "Arkay Mgmt Report")
					
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 