//(S) ibFG

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			If (User in group:C338(Current user:C182; "RoleOperations")) | (Current user:C182="Designer")
				$menu_items:=<>BASE_POPUP_MENU
			Else 
				$menu_items:="(New;(Modify...;Review..."
			End if 
			
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>0)
					ViewSetter($user_choice; ->[To_Do_Tasks_Sets:99])
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 