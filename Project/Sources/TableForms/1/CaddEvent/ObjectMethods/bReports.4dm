// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/06/13, 21:10:40
// ----------------------------------------------------
// Method: [zz_control].CaddEvent.bReports
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:="Vendor Listing;Performance;Outstanding POs"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=3)
					ViewSetter(78; ->[Vendors:7]; <>aVenRptPop{<>aVenRptPop})
				Else 
					ViewSetter(7; ->[Vendors:7]; <>aVenRptPop{<>aVenRptPop})
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 