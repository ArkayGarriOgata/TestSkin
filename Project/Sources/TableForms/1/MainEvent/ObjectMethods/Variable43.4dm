
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:=<>BASE_POPUP_MENU
			$user_choice:=Pop up menu:C542("(Customers;"+$menu_items)
			Case of 
				: ($user_choice>1)
					ViewSetter($user_choice-1; ->[Customers:16])
			End case 
			
		Else 
			$errCode:=uSpawnPalette("gCustEvent"; "$Customers Palette")
			If (False:C215)
				gCustEvent
			End if 
		End if 
		
End case 


//EOS