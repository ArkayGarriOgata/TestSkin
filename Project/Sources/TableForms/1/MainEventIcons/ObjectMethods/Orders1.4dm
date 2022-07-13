//(S) ibCustOrd
//StartOrds 

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2))
			$menu_items:="(Customer Orders;Enter via Project Center;Modify...;Review...;(-;Print..."
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=2)
					Pjt_ProjectUserInterface
					
				: ($user_choice=6)
					ViewSetter(7; ->[Customers_Orders:40]; "Cust_Order")
					
				: ($user_choice>2)
					ViewSetter($user_choice-1; ->[Customers_Orders:40])
			End case 
			
		Else 
			$errCode:=uSpawnPalette("gCustOrdEvent"; "$Customers' Order Palette")
			If (False:C215)
				gCustOrdEvent
			End if 
		End if 
		
End case 