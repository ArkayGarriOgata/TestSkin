If (Form event code:C388=On Clicked:K2:4)
	GET MOUSE:C468($clickX; $clickY; $mouse_btn)
	If (Macintosh control down:C544 | ($mouse_btn=2))
		$menu_items:="Project Center"
		$user_choice:=Pop up menu:C542($menu_items)
		Case of 
			: ($user_choice>0)
				Pjt_ProjectUserInterface
		End case 
	Else 
		Pjt_ProjectUserInterface
	End if 
End if 