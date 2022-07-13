//(S) ibFG

//EOS
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			If (User in group:C338(Current user:C182; "FGinventory"))
				If (User in group:C338(Current user:C182; "Planners"))
					$menu_items:="(Finished Goods;New via Project Center;Modify...;Review...;(-;AskMe;(-;Prep Services Tracking;Size-n-Style Tracking"
				Else 
					$menu_items:="(Finished Goods;(New via Project Center;(Modify...;Review...;(-;AskMe;(-;Prep Services Tracking;Size-n-Style Tracking"
				End if 
			Else 
				$menu_items:="(Finished Goods;New via Project Center;(Modify...;Review...;(-;(Prep Services Tracking;(Size-n-Style Tracking"
			End if 
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=6)
					sAskMe_UI
				: ($user_choice=8)
					<>Activitiy:=0
					ViewSetter(2; ->[Finished_Goods_Specifications:98])
				: ($user_choice=9)
					<>Activitiy:=2
					ViewSetter(2; ->[Finished_Goods_SizeAndStyles:132])
				: ($user_choice=2)
					Pjt_ProjectUserInterface
				: ($user_choice>2)
					ViewSetter($user_choice-1; ->[Finished_Goods:26])
			End case 
			
		Else 
			$errCode:=uSpawnPalette("FG_OpenPalette"; "$Finished Goods Palette")
			If (False:C215)
				FG_OpenPalette
			End if 
		End if 
		
End case 