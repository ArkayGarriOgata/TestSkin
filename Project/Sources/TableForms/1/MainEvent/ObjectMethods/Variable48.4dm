//(S) ibEst
//StartEstimating 

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:="(Estimates;New via Project Center;Modify...;Review..."
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=2)
					Pjt_ProjectUserInterface
				: ($user_choice>2)
					ViewSetter($user_choice-1; ->[Estimates:17])
			End case 
			
		Else 
			$errCode:=uSpawnPalette("ESTIMATE_OpenPalette"; "$Estimating Palette")
			If (False:C215)
				ESTIMATE_OpenPalette
			End if 
		End if 
		
End case 