// _______
// Method: [zz_control].RMEvent.ConsignmentsBtn   ( ) ->
// By: Mel Bohince @ 11/15/21, 12:18:50
// Description
// 
// ----------------------------------------------------

GET MOUSE:C468($clickX; $clickY; $mouse_btn)

If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
	If (User in group:C338(Current user:C182; "RoleCostAccountant"))
		$menu_items:="(Consignment;Setup...;Convert..."
	Else 
		$menu_items:="(Consignment;(Setup...;(Convert..."
	End if 
	$user_choice:=Pop up menu:C542($menu_items)
	Case of 
		: ($user_choice=2)
			uSpawnProcess("RM_Consignment_Receive"; 32000; "Transfer:Consignment Setup"; True:C214; False:C215)
			If (False:C215)  //list called procedures for 4D Insider
				RM_Consignment_Receive
			End if 
			
		: ($user_choice=3)
			uSpawnProcess("RM_Consignment_Conver"; 32000; "Transfer:Consignment Receipt"; True:C214; False:C215)
			If (False:C215)  //list called procedures for 4D Insider
				RM_Consignment_Conver
			End if 
	End case 
	
Else 
	uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
End if 

