// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/07/13, 10:54:05
// ----------------------------------------------------
// Method: [zz_control].FGEvent.bReport
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:=<>aFGRptPopMenu
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice>0)
					ViewSetter(35; ->[Finished_Goods:26]; <>aFGRptPop{$user_choice})
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 