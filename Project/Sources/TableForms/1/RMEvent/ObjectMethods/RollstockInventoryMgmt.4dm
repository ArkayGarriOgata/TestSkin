// _______
// Method: [zz_control].RMEvent.RollstockInventoryMgmt   ( ) ->
// By: Mel Bohince @ 11/15/21, 12:05:23
// Description
// 
// ----------------------------------------------------

GET MOUSE:C468($clickX; $clickY; $mouse_btn)

If (Macintosh control down:C544 | ($mouse_btn=2)) | (True:C214)
	
	Case of 
		: (User in group:C338(Current user:C182; "RoleCostAccountant"))
			$menu_items:="(RM Labels;Create...;Update...;Reconcile...;(-;(Match..."
			
		: (User in group:C338(Current user:C182; "RMreceiveRtn"))
			$menu_items:="(RM Labels;Create...;Update...;(Reconcile...;(-;(Match..."
			
		Else 
			$menu_items:="(RM Labels;(Create;(Update...(;Reconcile...;(-;(Match..."
	End case 
	
	If (User in group:C338(Current user:C182; "RMreceiveRtn"))
		
	Else 
		
	End if 
	$user_choice:=Pop up menu:C542($menu_items)
	Case of 
		: ($user_choice=2)
			$pid:=New process:C317("RIM_CreateLabels"; <>lMidMemPart; "RIM_CreateLabels"; "create")
			
			
		: ($user_choice=3)
			ViewSetter(2; ->[Raw_Material_Labels:171])
			
		: ($user_choice=4)
			RIM_ReconcileInventory
			
		: ($user_choice=6)  //this should be disabled
			//uConfirm ("Match RM_Location qty's to the RM_Label qty's?";"Proceed";"Cancel")
			//If (False)  //(ok=1)
			//RIM_ReconcileInventoryAuto 
			//End if 
			BEEP:C151
			
	End case 
	
Else 
	uConfirm("Either right+click or hold down Control key and click."; "OK"; "Help")
End if 

