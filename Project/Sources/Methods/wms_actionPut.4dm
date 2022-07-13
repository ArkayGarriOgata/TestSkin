//%attributes = {"publishedWeb":true}
//action_put(item,container)
actionPerformed:=False:C215
$case:=$1
$pallet:=$2

If (Not:C34(wms_compExists($case; $pallet)))  //not previously put into this container
	
	If (wms_itemExists($case))  // has it been register in the [WMS_ItemMaster]
		$cust:=[WMS_ItemMasters:123]CUST:9
		$sku:=[WMS_ItemMasters:123]SKU:2
		$lot:=[WMS_ItemMasters:123]LOT:3
		REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
		If (wms_compExists(""; ""; $case))  //if it is on another skid, take it off
			wms_actionTake($case)  //should be slam dunk since already validated
			actionPerformed:=False:C215  //reset, we're not done yet
		End if 
		
		If (wms_itemExists($pallet))  //is the container valid
			[WMS_ItemMasters:123]QTY:7:=[WMS_ItemMasters:123]QTY:7+1
			[WMS_ItemMasters:123]UOM:6:="SKID"
			$currentLocation:=[WMS_ItemMasters:123]LOCATION:4
			If (Not:C34(wms_compExists($pallet)))
				wms_itemLikeOther($cust; $sku; $lot)  //container is like content
			Else 
				If (([WMS_ItemMasters:123]CUST:9+[WMS_ItemMasters:123]SKU:2+[WMS_ItemMasters:123]LOT:3)#($cust+$sku+$lot))
					wms_itemLikeOther("MIX"; "MIX"; "MIX")
				End if 
			End if 
			SAVE RECORD:C53([WMS_ItemMasters:123])
			REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
			
			CREATE RECORD:C68([WMS_Compositions:124])
			[WMS_Compositions:124]Content:2:=$case
			[WMS_Compositions:124]Container:1:=$pallet
			[WMS_Compositions:124]CompKey:3:=$case+$pallet
			SAVE RECORD:C53([WMS_Compositions:124])
			actionPerformed:=True:C214
			
			If (Length:C16($currentLocation)>0)
				wms_actionMove($pallet; $currentLocation)
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("Item "+$pallet+" is unknown")
		End if 
		
	Else 
		BEEP:C151
		ALERT:C41("Item "+$case+" is unknown")
	End if 
	
Else   //already recorded
	BEEP:C151
	ALERT:C41($case+" is already on "+$pallet)
End if 