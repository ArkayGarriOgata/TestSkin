//(S) bsAEC

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:="Job Master Log"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>0)
					app_Log_Usage("log"; "Job Master Log"; "")
					JML_ShowListing
			End case 
			
		Else 
			app_Log_Usage("log"; "Job Master Log"; "")
			JML_ShowListing
		End if 
		
End case 
