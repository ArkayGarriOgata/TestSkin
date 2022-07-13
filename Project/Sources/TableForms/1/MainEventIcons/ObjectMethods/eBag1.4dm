Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:="Electronic Job Bag;Bag Tracker"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					eBag_UI
				: ($user_choice=2)
					app_Log_Usage("log"; "Bag Tracker"; "")
					JTB_bagTrack_UI
			End case 
			
		Else 
			eBag_UI
		End if 
		
End case 