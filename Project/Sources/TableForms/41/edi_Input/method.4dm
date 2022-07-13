Case of 
	: (Form event code:C388=On Load:K2:1)
		change_ams_status:=False:C215
		iMode:=2  //used by standard Release input screen
		If ([Customers_Order_Lines:41]edi_line_status:55="Reviewed")
			bReviewed:=1
			If (Position:C15("ACCEPT WITHOUT AMENDMENT"; [Customers_Order_Lines:41]edi_FreeText1:58)>0)
				cb1:=1  //accept without amendment
				[Customers_Order_Lines:41]edi_FreeText1:58:=[Customers_Order_Lines:41]edi_FreeText1:58+" "  //tickle on validate
			Else 
				cb1:=0  //accept with amendment
				[Customers_Order_Lines:41]edi_FreeText1:58:=[Customers_Order_Lines:41]edi_FreeText1:58+" "  //tickle on validate
			End if 
			
		Else 
			bReviewed:=0
			cb1:=1  //accept without amendment
			[Customers_Order_Lines:41]edi_FreeText1:58:=[Customers_Order_Lines:41]edi_FreeText1:58+" "  //tickle on validate
		End if 
		
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
		COPY NAMED SELECTION:C331([Customers_ReleaseSchedules:46]; "its_releases")
		
		RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
		
		$change_color:=-(3+(256*0))
		$same_color:=-(15+(256*0))
		
		If ([Customers_Order_Lines:41]Quantity:6#[Customers_Order_Lines:41]edi_quantity:65)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]Quantity:6; $change_color; True:C214)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_quantity:65; $change_color; True:C214)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]Quantity:6; $same_color; True:C214)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_quantity:65; $same_color; True:C214)
		End if 
		
		If ([Customers_Order_Lines:41]NeedDate:14#[Customers_Order_Lines:41]edi_dock_date:64)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]NeedDate:14; $change_color)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_dock_date:64; $change_color)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]NeedDate:14; $same_color)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_dock_date:64; $same_color)
		End if 
		
		If ([Customers_Order_Lines:41]defaultShipTo:17#[Customers_Order_Lines:41]edi_shipto:63)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]defaultShipTo:17; $change_color)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_shipto:63; $change_color)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]defaultShipTo:17; $same_color)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_shipto:63; $same_color)
		End if 
		
		If ([Customers_Order_Lines:41]Price_Per_M:8#[Customers_Order_Lines:41]edi_price:66)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]Price_Per_M:8; $change_color)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_price:66; $change_color)
		Else 
			Core_ObjectSetColor(->[Customers_Order_Lines:41]Price_Per_M:8; $same_color)
			Core_ObjectSetColor(->[Customers_Order_Lines:41]edi_price:66; $same_color)
		End if 
		
		[Customers_Order_Lines:41]edi_response_code:62:=5
		//edi_is_send_change 
		
		If ([Customers_Order_Lines:41]Quantity:6#[Customers_Order_Lines:41]edi_quantity:65)
			[Customers_Order_Lines:41]edi_response_code:62:=6
			//uConfirm ("Our quantity doesn't match, please use theirs.";"OK";"They insist")
		End if 
		
		If ([Customers_Order_Lines:41]NeedDate:14#[Customers_Order_Lines:41]edi_dock_date:64)
			[Customers_Order_Lines:41]edi_response_code:62:=6
		End if 
		
		If ([Customers_Order_Lines:41]defaultShipTo:17#[Customers_Order_Lines:41]edi_shipto:63)
			[Customers_Order_Lines:41]edi_response_code:62:=6
		End if 
		
		If ([Customers_Order_Lines:41]Price_Per_M:8#[Customers_Order_Lines:41]edi_price:66)
			[Customers_Order_Lines:41]edi_response_code:62:=6
			//uConfirm ("Our price doesn't match, please use theirs.";"OK";"They insist")
		End if 
		
		If ([Customers_Order_Lines:41]edi_response_code:62=6)
			[Customers_Order_Lines:41]edi_FreeText1:58:="ACCEPT WITH AMENDMENT"
		Else 
			[Customers_Order_Lines:41]edi_FreeText1:58:="ACCEPT WITHOUT AMENDMENT"
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		If (bReviewed=0)  //case user forgot
			uConfirm("Mark as Reviewed?"; "Yes"; "No")
			If (ok=1)
				[Customers_Order_Lines:41]edi_line_status:55:="Reviewed"
			End if 
		End if 
		
		If (cb1=1)  //respond just as they sent it, "without amendment"
			[Customers_Order_Lines:41]edi_response_code:62:=5
			
			If ([Customers_Order_Lines:41]defaultShipTo:17#[Customers_Order_Lines:41]edi_shipto:63)
				[Customers_Order_Lines:41]defaultShipTo:17:=[Customers_Order_Lines:41]edi_shipto:63
				USE NAMED SELECTION:C332("its_releases")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10:=[Customers_Order_Lines:41]defaultShipTo:17)
			End if 
			
			If ([Customers_Order_Lines:41]NeedDate:14#[Customers_Order_Lines:41]edi_dock_date:64)
				[Customers_Order_Lines:41]NeedDateOld:51:=[Customers_Order_Lines:41]NeedDate:14
				[Customers_Order_Lines:41]NeedDate:14:=[Customers_Order_Lines:41]edi_dock_date:64
				edi_use_their_date
			End if 
			
			If ([Customers_Order_Lines:41]Quantity:6#[Customers_Order_Lines:41]edi_quantity:65)
				[Customers_Order_Lines:41]Quantity:6:=[Customers_Order_Lines:41]edi_quantity:65
				edi_use_their_quantity
			End if 
			
			If ([Customers_Order_Lines:41]Price_Per_M:8#[Customers_Order_Lines:41]edi_price:66)
				[Customers_Order_Lines:41]Price_Per_M:8:=[Customers_Order_Lines:41]edi_price:66
				[Customers_Order_Lines:41]chgd_price:27:=True:C214
				change_ams_status:=True:C214
				FG_Contract_Price_Change([Customers_Order_Lines:41]ProductCode:5; [Customers_Order_Lines:41]Price_Per_M:8)
			End if 
			
		Else 
			If ([Customers_Order_Lines:41]Quantity:6#[Customers_Order_Lines:41]edi_quantity:65)
				[Customers_Order_Lines:41]edi_response_code:62:=6
			End if 
			
			If ([Customers_Order_Lines:41]NeedDate:14#[Customers_Order_Lines:41]edi_dock_date:64)
				[Customers_Order_Lines:41]edi_response_code:62:=6
			End if 
			
			If ([Customers_Order_Lines:41]defaultShipTo:17#[Customers_Order_Lines:41]edi_shipto:63)
				[Customers_Order_Lines:41]edi_response_code:62:=6
			End if 
			
			If ([Customers_Order_Lines:41]Price_Per_M:8#[Customers_Order_Lines:41]edi_price:66)
				[Customers_Order_Lines:41]edi_response_code:62:=6
			End if 
		End if 
		
		If ([Customers_Order_Lines:41]edi_response_code:62=6)
			[Customers_Order_Lines:41]edi_FreeText1:58:="ACCEPT WITH AMENDMENT"
		Else 
			[Customers_Order_Lines:41]edi_FreeText1:58:="ACCEPT WITHOUT AMENDMENT"
		End if 
		
		
		If ([Customers_Order_Lines:41]Status:9#"closed")  //don't mess with closed orderline statii
			If (change_ams_status)  //don't rebook if only a date or destination change
				[Customers_Order_Lines:41]Status:9:="CONTRACT"
				If ([Customers_Orders:40]Status:10="Accepted") | ([Customers_Orders:40]Status:10="")
					[Customers_Orders:40]Status:10:="CONTRACT"
				End if 
			End if 
		End if 
		
		
End case 
