//%attributes = {"publishedWeb":true}
//PM: wms_actionMove() -> 
//@author Mel - 5/9/03  16:33

//action_move(item,location)
actionPerformed:=False:C215
$goodItem:=wms_itemExists($1)
$goodLocation:=wms_locationExists($2)

If ($goodItem) & ($goodLocation)
	wms_itemSetLocation($2)
	REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
	
	If (wms_compExists($1))  //updates its items
		wms_compGetItems
		wms_compSetItemLocation($2)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
			
		Else 
			//see line 32
		End if   // END 4D Professional Services : January 2019 
		
	End if 
	
	actionPerformed:=True:C214
Else 
	BEEP:C151
	ALERT:C41("Unknown item "+$1+" or location "+$2)
End if 

REDUCE SELECTION:C351([WMS_ItemMasters:123]; 0)
REDUCE SELECTION:C351([WMS_AllowedLocations:73]; 0)