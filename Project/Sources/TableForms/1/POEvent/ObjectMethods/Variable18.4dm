
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>aPORptPopMenu
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)  //laser PO printing
					ViewSetter(78; ->[Purchase_Orders:11]; <>aPORptPop{$user_choice})
				: ($user_choice=5)  //PO print only
					ViewSetter(78; ->[Purchase_Orders:11]; <>aPORptPop{$user_choice})
				: ($user_choice=6)  //
					ViewSetter(78; ->[Purchase_Orders:11]; <>aPORptPop{$user_choice})
				: ($user_choice=7)
					ViewSetter(78; ->[Purchase_Orders:11]; <>aPORptPop{$user_choice})
				: ($user_choice=9)  //Short Lead time
					ViewSetter(78; ->[Purchase_Orders:11]; <>aPORptPop{$user_choice})
				: ($user_choice=10)  //Last Weeks Purchases
					ViewSetter(78; ->[Purchase_Orders:11]; <>aPORptPop{$user_choice})
				Else 
					ViewSetter(7; ->[Purchase_Orders:11]; <>aPORptPop{$user_choice})
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 