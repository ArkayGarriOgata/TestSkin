//%attributes = {"publishedWeb":true}
//PM: wms_actionTake() -> 
//@author Mel - 5/9/03  16:32

//action_take(item)
actionPerformed:=False:C215
If (wms_itemExists($1))
	REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
	
	If (wms_compExists(""; ""; $1))
		$container:=[WMS_Compositions:124]Container:1
		DELETE RECORD:C58([WMS_Compositions:124])
		
		If (wms_itemExists($container))
			[WMS_ItemMasters:123]QTY:7:=[WMS_ItemMasters:123]QTY:7-1
			If ([WMS_ItemMasters:123]QTY:7<1)  //container is empty
				[WMS_ItemMasters:123]CUST:9:=""
				[WMS_ItemMasters:123]SKU:2:=""
				[WMS_ItemMasters:123]LOT:3:=""
			End if 
			SAVE RECORD:C53([WMS_ItemMasters:123])
			REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
		End if 
		
		actionPerformed:=True:C214
		
	Else 
		BEEP:C151
		ALERT:C41("Item "+$1+" not found on any container")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Unkown item "+$1)
End if 