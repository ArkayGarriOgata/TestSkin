Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:="Supply and Demand Details"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>0)
					sAskMe_UI
			End case 
			
		Else 
			sAskMe_UI
		End if 
		
End case 
