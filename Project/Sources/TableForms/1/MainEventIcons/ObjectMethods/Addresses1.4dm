Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$enabled:=<>BASE_POPUP_MENU
			$disabled:="(New;(Modify...;(Review..."
			If (User in group:C338(Current user:C182; "Addresses"))
				$menu_items:="(Addresses;"+$enabled
			Else 
				$menu_items:="(Addresses;"+$disabled
			End if 
			
			If (User in group:C338(Current user:C182; "Contacts"))
				$menu_items:=$menu_items+";(Contacts;"+$enabled
			Else 
				$menu_items:=$menu_items+";(Contacts;"+$disabled
			End if 
			
			If (User in group:C338(Current user:C182; "Vendors"))
				$menu_items:=$menu_items+";(Vendors;"+$enabled
			Else 
				$menu_items:=$menu_items+";(Vendors;"+$disabled
			End if 
			
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>1) & ($user_choice<5)
					ViewSetter($user_choice-1; ->[Addresses:30])
					
				: ($user_choice>5) & ($user_choice<9)
					ViewSetter($user_choice-5; ->[Contacts:51])
					
				: ($user_choice>9) & ($user_choice<13)
					ViewSetter($user_choice-9; ->[Vendors:7])
			End case 
			
		Else 
			$errCode:=uSpawnPalette("gCaddEvent"; "$Address Palette")
			If (False:C215)
				gCaddEvent
			End if 
		End if 
		
End case   //(S) ibCadd
//StartAddr 

//EOS