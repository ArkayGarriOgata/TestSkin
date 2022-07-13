// _______
// Method: [zz_control].RMEvent.PO_ReleasesBtn   ( ) ->
// By: Mel Bohince @ 11/15/21, 12:18:24
// Description
// 
// ----------------------------------------------------

GET MOUSE:C468($clickX; $clickY; $mouse_btn)

If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
	If (User in group:C338(Current user:C182; "BoardScheduler"))  //&(False)
		$menu_items:="New PO Release;Modify...;Review...;Delete..."
	Else 
		$menu_items:="(New PO Release;(Modify...;Review...;(Delete..."
	End if 
	$user_choice:=Pop up menu:C542($menu_items)
	Case of 
		: ($user_choice>0)
			ViewSetter($user_choice; ->[Purchase_Orders_Releases:79])
	End case 
	
Else 
	uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
End if 

