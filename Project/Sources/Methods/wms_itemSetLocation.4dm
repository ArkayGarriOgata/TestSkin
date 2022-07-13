//%attributes = {"publishedWeb":true}
//PM: wms_itemSetLocation() -> 
//@author Mel - 5/9/03  16:55

//item_setLocation
If ([WMS_ItemMasters:123]LOCATION:4#$1)
	[WMS_ItemMasters:123]LOCATION:4:=$1
	SAVE RECORD:C53([WMS_ItemMasters:123])
End if 