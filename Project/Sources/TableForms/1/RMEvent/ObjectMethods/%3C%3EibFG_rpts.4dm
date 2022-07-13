// ----------------------------------------------------
// Method: [zz_control].RMEvent.<>ibFG_rpts
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			If (User in group:C338(Current user:C182; "RMallocation"))
				$menu_items:="New Allocation;Modify...;Review...;Delete..."
			Else 
				$menu_items:="(New Allocation;(Modify...;Review...;(Delete..."
			End if 
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>0)
					ViewSetter($user_choice; ->[Raw_Materials_Allocations:58])
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 