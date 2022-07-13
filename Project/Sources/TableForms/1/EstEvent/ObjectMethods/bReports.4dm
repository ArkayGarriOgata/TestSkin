// ----------------------------------------------------
// Method: [zz_control].EstEvent.bReports
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		GET MOUSE:C468($clickX; $clickY; $mouse_btn)
		
		If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
			$menu_items:="RFQ;(-;Cost & Qty Estimate;Quote;Preparatory Costs"
			$user_choice:=Pop up menu:C542($menu_items)
			Case of 
				: ($user_choice=1)
					ViewSetter(7; ->[Estimates:17]; "RFQ")
				: ($user_choice=3)
					ViewSetter(7; ->[Estimates:17]; "Cost & Qty Estimate")
				: ($user_choice=4)
					ViewSetter(7; ->[Estimates:17]; "Quote")
				: ($user_choice=5)
					ViewSetter(7; ->[Estimates:17]; "Preparatory Costs")
			End case 
			
		Else 
			uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
		End if 
End case 