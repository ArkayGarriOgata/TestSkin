Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:=<>BASE_POPUP_MENU
			$user_choice:=Pop up menu:C542("(Salesmen;"+$menu_items)
			Case of 
				: ($user_choice>1)
					Sales_ControlCenter
			End case 
			
		Else 
			app_Log_Usage("log"; "Sales Reps' Palette"; "")
			$errCode:=uSpawnPalette("gSaleEvent"; "$Sales Reps' Palette")
			If (False:C215)
				gSaleEvent
			End if 
		End if 
		
End case   //(S) ibSale
//StartSales 

//EOS