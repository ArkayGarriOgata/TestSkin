//(S) ibFG

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>BASE_POPUP_MENU
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					ViewSetter(1; ->[QA_Corrective_Actions:105])
				: ($user_choice=2)
					<>iMode:=2
					<>filePtr:=->[QA_Corrective_Actions:105]
					uSpawnProcess("CAR_userInterface"; <>lMinMemPart; "Corrective Action"; True:C214; False:C215)
				: ($user_choice=3)
					<>iMode:=3
					<>filePtr:=->[QA_Corrective_Actions:105]
					uSpawnProcess("CAR_userInterface"; <>lMinMemPart; "Corrective Action"; True:C214; True:C214)
					If (False:C215)
						CAR_userInterface
					End if 
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 