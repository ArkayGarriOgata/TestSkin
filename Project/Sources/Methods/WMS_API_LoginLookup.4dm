//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_LoginLookup - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284(<>ttWMS_CONFIG_MySQL; <>ttWMS_CONFIG_4D; <>WMS_ALT_LABELS)
C_BOOLEAN:C305(<>fWMS_Use4D)
<>ttWMS_CONFIG_MySQL:=""
<>ttWMS_CONFIG_4D:=""
<>fWMS_Use4D:=False:C215

READ ONLY:C145([zz_control:1])
ALL RECORDS:C47([zz_control:1])
If (Records in selection:C76([zz_control:1])>0)
	<>fWMS_Use4D:=[zz_control:1]wms_connection_Use4D:66
	<>ttWMS_CONFIG_4D:=[zz_control:1]wms_connection_4D:65
	<>ttWMS_CONFIG_MySQL:=[zz_control:1]wms_connection_mysql:58
	<>ttWMS_4D_URL:=[zz_control:1]wms_4D_url:67
	<>WMS_ALT_LABELS:=[zz_control:1]wms_alternateLabel:59
End if 
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	REDUCE SELECTION:C351([zz_control:1]; 0)
	UNLOAD RECORD:C212([zz_control:1])
	
Else 
	
	REDUCE SELECTION:C351([zz_control:1]; 0)
	
End if   // END 4D Professional Services : January 2019 
