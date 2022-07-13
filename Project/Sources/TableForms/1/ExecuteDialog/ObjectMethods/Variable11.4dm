//(S) ibFG

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=""
			For ($i; 1; Size of array:C274(<>acommand))
				$menu_items:=$menu_items+<>acommand{$i}+";"
			End for 
			$menu_items:=Replace string:C233($menu_items; "("; " ")
			$user_choice:=Pop up menu:C542(Substring:C12($menu_items; 1; Length:C16($menu_items)-1))
			Case of 
				: ($user_choice>0)
					vcommand:=<>acommand{$user_choice}
					HIGHLIGHT TEXT:C210(vcommand; 1; 100)
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 