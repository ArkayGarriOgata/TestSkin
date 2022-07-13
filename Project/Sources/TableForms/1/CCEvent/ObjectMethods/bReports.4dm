// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/06/13, 21:10:40
// ----------------------------------------------------
// Method: [zz_control].CCEvent.bReports
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:="Cost Center Listing"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					ViewSetter(7; ->[Cost_Centers:27]; "Cost Center Listing")
					
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 