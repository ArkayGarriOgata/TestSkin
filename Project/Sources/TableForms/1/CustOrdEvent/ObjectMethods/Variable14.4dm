// _______
// Method: [zz_control].CustOrdEvent.Reportspopup   ( ) ->
// Description
// 
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>aCORptPopMenu
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=0)
				: ($user_choice=2)
					ViewSetter(7; ->[Customers_Order_Change_Orders:34]; <>aCORptPop{$user_choice})
				: ($user_choice=3)
					ViewSetter(7; ->[Customers_Order_Change_Orders:34]; <>aCORptPop{$user_choice})
				: ($user_choice=6)
					ViewSetter(7; ->[Customers_Orders:40]; <>aCORptPop{$user_choice})
				: ($user_choice=7)
					ViewSetter(7; ->[Customers_Orders:40]; <>aCORptPop{$user_choice})
				: ($user_choice=4)
					ViewSetter(78; ->[Customers_Order_Lines:41]; <>aCORptPop{$user_choice})  //Expirations
				: ($user_choice=10)
					ViewSetter(78; ->[Customers_Order_Lines:41]; <>aCORptPop{$user_choice})  //Expirations
				: ($user_choice=9)
					$id:=New process:C317("ORD_distributionSummary"; <>lMinMemPart; "Prep Billing Summary")
					If (False:C215)
						ORD_distributionSummary
					End if 
				: ($user_choice=11)
					ViewSetter(78; ->[Customers_Order_Lines:41]; <>aCORptPop{$user_choice})  //No cost orderlines
					
					//: ($user_choice=12)
					//ViewSetter (78;->[Customers_Invoices];<>aCORptPop{$user_choice})  //ytd billings
					
				Else 
					ViewSetter(7; ->[Customers_Orders:40]; <>aCORptPop{$user_choice})
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 