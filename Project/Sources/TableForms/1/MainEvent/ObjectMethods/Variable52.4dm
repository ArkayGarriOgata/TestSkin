Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:="Raw Material and Cost Center Standards"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>0)
					app_Log_Usage("log"; "Standards Palette"; "")
					$errCode:=uSpawnPalette("gCCEvent"; "$Standards Palette")
					//EOS
					If (False:C215)
						gCCEvent
					End if 
			End case 
			
		Else 
			app_Log_Usage("log"; "Standards Palette"; "")
			$errCode:=uSpawnPalette("gCCEvent"; "$Standards Palette")
			//EOS
			If (False:C215)
				gCCEvent
			End if 
		End if 
		
End case   //(S) ibCC
//StartCC 
