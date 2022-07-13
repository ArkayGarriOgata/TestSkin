//(S) ibFG

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>aQARptPopMenu
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>1)
					$pid:=New process:C317("QA_Reports"; <>lMidMemPart; "QA Reports"; <>aQARptPop{$user_choice})
					If (False:C215)
						QA_Reports
					End if 
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 