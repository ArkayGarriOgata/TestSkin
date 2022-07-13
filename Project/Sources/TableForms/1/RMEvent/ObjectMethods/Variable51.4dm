//(S) ibFG

GET MOUSE:C468($clickX; $clickY; $mouse_btn)

If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
	$menu_items:=<>aRmRptPopMenu
	$user_choice:=Pop up menu:C542($menu_items)
	Case of 
		: ($user_choice=16) | ($user_choice=20) | ($user_choice=21) | ($user_choice=22)
			ViewSetter(30; ->[Raw_Materials:21]; <>aRMRptPop{$user_choice})
			
		: ($user_choice>4)  //10/29/94
			ViewSetter(78; ->[Raw_Materials:21]; <>aRMRptPop{$user_choice})
			
		Else   //1,3,4
			ViewSetter(30; ->[Raw_Materials:21]; <>aRMRptPop{$user_choice})
	End case 
	
Else 
	uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
End if 

