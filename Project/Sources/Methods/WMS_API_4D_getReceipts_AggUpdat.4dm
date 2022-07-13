//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getReceipts_AggUpdat - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($ttSQL)

$ttSQL:="UPDATE ams_exports SET transaction_state_indicator = 'X' "
$ttSQL:=$ttSQL+"WHERE transaction_state_indicator = 'T' AND transaction_type_code = 100"

SQL EXECUTE:C820($ttSQL)