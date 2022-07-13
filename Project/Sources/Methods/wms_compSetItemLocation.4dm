//%attributes = {"publishedWeb":true}
//PM: wms_compSetItemLocation() -> 
//@author Mel - 5/9/03  16:54

//comp_setItemsLocation
ARRAY TEXT:C222($aLoc; 0)
SELECTION TO ARRAY:C260([WMS_ItemMasters:123]LOCATION:4; $aLoc)
For ($i; 1; Size of array:C274($aLoc))
	$aLoc{$i}:=$1
End for 
ARRAY TO SELECTION:C261($aLoc; [WMS_ItemMasters:123]LOCATION:4)

If (Records in set:C195("LockedSet")>0)
	BEEP:C151
	ALERT:C41("some items were locked and didn't have their location updated")
End if 