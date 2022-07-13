// ----------------------------------------------------
// Method: [zz_control].FGEvent.<>ib_sscc
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			If (User in group:C338(Current user:C182; "RoleMaterialHandler"))
				$menu_items:="New SSCC;Update..."
			Else 
				$menu_items:="(New SSCC;(Update..."
			End if 
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					uSpawnProcess("Barcode_SSCC_PnG"; <>lMinMemPart; "SSCC"; True:C214; False:C215)
					
				: ($user_choice=2)
					ViewSetter(2; ->[WMS_SerializedShippingLabels:96])
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 