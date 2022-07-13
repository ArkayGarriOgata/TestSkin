Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			If (User in group:C338(Current user:C182; "RoleQA"))
				$menu_items:=<>BASE_POPUP_MENU
			Else 
				$menu_items:="(New;(Modify;Review"
			End if 
			$user_choice:=Pop up menu:C542("(Corrective Actions;"+$menu_items)
			Case of 
				: ($user_choice>1)
					ViewSetter($user_choice-1; ->[QA_Corrective_Actions:105])
			End case 
			
		Else 
			prQA2Front
		End if 
		
End case   //(S) ibCustOrd

//$errCode:=uSpawnPalette ("QA_openPalette";"$QA Palette")
//EOS