SET QUERY DESTINATION:C396(Into variable:K19:4; $exists)
QUERY:C277([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]ValidLocation:1=[WMS_AllowedLocations:73]ValidLocation:1)
SET QUERY DESTINATION:C396(Into current selection:K19:1)
If ($exists=0)
	[WMS_AllowedLocations:73]BarcodedID:2:=wms_convert_bin_id("wms"; [WMS_AllowedLocations:73]ValidLocation:1)  //FGL_MakeFGbinID ([WMS_AllowedLocations]ValidLocation)
Else 
	uConfirm([WMS_AllowedLocations:73]ValidLocation:1+" has already been setup, try something else."; "OK"; "Help")
	[WMS_AllowedLocations:73]ValidLocation:1:=""
	[WMS_AllowedLocations:73]BarcodedID:2:=""
	GOTO OBJECT:C206([WMS_AllowedLocations:73]ValidLocation:1)
End if 