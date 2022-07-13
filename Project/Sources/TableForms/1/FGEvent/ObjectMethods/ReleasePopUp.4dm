// _______
// Method: [zz_control].FGEvent.ReleasePopUp   ( ) ->
// Description
// 
// ----------------------------------------------------
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			If (User in group:C338(Current user:C182; "CustomerService"))
				$menu_items:="(Create new Releases from the AskMe screen;Modify...;Review...;(-;"
			Else 
				$menu_items:="(Create new Releases from the AskMe screen;(Modify...;Review...;(-;"
			End if 
			
			If (User in group:C338(Current user:C182; "ASN_sender"))
				$menu_items:=$menu_items+"ELC Shipping..."
			Else 
				$menu_items:=$menu_items+"(ELC Shipping..."
			End if 
			
			$menu_items:=$menu_items+";P&G Shipping..."
			
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>0) & (($user_choice<4))
					ViewSetter($user_choice; ->[Customers_ReleaseSchedules:46])
					
				: ($user_choice=5)
					$pid:=New process:C317("Release_UI"; 0; "ELC_Shipping")  //EDI_DESADV_PO_Notification 
					
				: ($user_choice=6)
					$pid:=New process:C317("Release_UI_PnG"; 0; "PnG_Shipping")  //EDI_DESADV_PO_Notification 
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
		
End case 