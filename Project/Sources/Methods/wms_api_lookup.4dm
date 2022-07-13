//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_lookup - Created v0.1.0-JJG (05/09/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

If (<>fWMS_Use4D)
	WMS_API_4D_lookup
	
Else 
	wms_api_MySQL_lookup
	
End if 