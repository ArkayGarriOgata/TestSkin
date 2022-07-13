//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_DoLogin - Created v0.1.0-JJG (05/06/16)
///
///*** make sure WMS_API_LoginLookup was called at some point prior to set credentials up

If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fLoggedIn)
C_TEXT:C284($ttErrorMeth)

$fLoggedIn:=False:C215

$ttErrorMeth:=Method called on error:C704
ON ERR CALL:C155("WMS_API_4D_SQLErrorCatch")
$xlTimes:=0
$fGetOut:=False:C215
Repeat 
	$xlTimes:=$xlTimes+1
	SQL LOGIN:C817("IP:"+WMS_API_4D_GetLoginHost+":"+WMS_API_4D_GetLoginPort; WMS_API_4D_GetLoginUser; WMS_API_4D_GetLoginPassword; *)
	$fLoggedIn:=(OK=1)
	$fGetOut:=(($xlTimes>3) | $fLoggedIn)
	
	If (Not:C34($fGetOut))
		DELAY PROCESS:C323(Current process:C322; (60*5))
	End if 
Until ($fGetOut)

If (Not:C34($fLoggedIn))
	utl_Logfile("wms_api.Log"; "### ERROR: Could not establish connection to WMS")
End if 
ON ERR CALL:C155($ttErrorMeth)

$0:=$fLoggedIn