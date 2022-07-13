Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			
			If (User in group:C338(Current user:C182; "RMcreate"))
				$menu_items:="New"
			Else 
				$menu_items:="(New"
			End if 
			
			If (User in group:C338(Current user:C182; "RMupdate"))
				$menu_items:=$menu_items+";Modify..."
			Else 
				$menu_items:=$menu_items+";(Modify..."
			End if 
			
			If (User in group:C338(Current user:C182; "RMinquire"))
				$menu_items:=$menu_items+";Review..."
			Else 
				$menu_items:=$menu_items+";(Review..."
			End if 
			
			$user_choice:=Pop up menu:C542("(Raw Materials;"+$menu_items)
			Case of 
				: ($user_choice>1)
					ViewSetter($user_choice-1; ->[Raw_Materials:21])
			End case 
			
		Else 
			$errCode:=uSpawnPalette("RM_OpenPalette"; "$Raw Material Palette")
			If (False:C215)
				RM_OpenPalette
			End if 
		End if 
		
End case 