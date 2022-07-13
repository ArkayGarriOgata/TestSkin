//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_SendSkidErrorLog - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($1; $fSuccess)
C_TEXT:C284($2; $ttError)
$fSuccess:=$1
$ttError:=$2

If (Not:C34($fSuccess))
	utl_LogIt("init")
	utl_LogIt(" === ")
	utl_LogIt(" PALLET NOT SAVED, PROBLEMS:  ")
	utl_LogIt(" === ")
	utl_LogIt($ttErrors)
	utl_LogIt("show")
End if 