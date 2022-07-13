Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			If (User in group:C338(Current user:C182; "Purchasing Modify"))
				$menu_items:=<>BASE_POPUP_MENU
			Else 
				$menu_items:="(New;(Modify...;Review"
			End if 
			
			$user_choice:=Pop up menu:C542("(Purchase Orders;"+$menu_items)
			Case of 
				: ($user_choice>1)
					If (User in group:C338(Current user:C182; "AccountsPayable"))
						$id:=uSpawnProcess("PoAcctReview"; 0; "Review Purchase Orders"; True:C214; True:C214)
						If (False:C215)  //insider reference
							PoAcctReview
						End if 
					Else 
						ViewSetter($user_choice-1; ->[Purchase_Orders:11])
					End if 
			End case 
			
		Else 
			$errCode:=uSpawnPalette("PO_OpenPalette"; "$Purchasing Palette")
			If (False:C215)
				PO_OpenPalette
			End if 
		End if 
		
End case   //(S) ibPO
//StartPO 

//EOS
