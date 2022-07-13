//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_deleteSelCases - Created v0.1.0-JJG (05/12/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

If (<>fWMS_Use4D)
	WMS_API_4D_deleteSelCases
	
Else 
	wms_api_MySQL_deleteSelCases
	
End if 