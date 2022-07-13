//(S) ibFG

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>BASE_POPUP_MENU
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)  //new
					QA_CustNewTestStd
				: ($user_choice=2)  //modify
					ViewSetter($user_choice; ->[QA_CustomerTestStandards:135])
				: ($user_choice=3)  //review
					ViewSetter($user_choice; ->[QA_CustomerTestStandards:135])
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 