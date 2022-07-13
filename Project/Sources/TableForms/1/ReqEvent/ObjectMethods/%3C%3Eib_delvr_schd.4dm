// ----------------------------------------------------
// Method: [zz_control].ReqEvent.bReport
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:="Requisition"  //;Requisition Listing"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					ViewSetter(78; ->[Purchase_Orders:11]; "Requisition")
					
				: ($user_choice=2)
					ViewSetter(78; ->[Purchase_Orders:11]; "Requisition Listing")
					
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 