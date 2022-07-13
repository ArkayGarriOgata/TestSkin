//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_GetLoginUser - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($xlColonPos)

$xlColonPos:=Position:C15(":"; <>ttWMS_CONFIG_4D)
$0:=Substring:C12(<>ttWMS_CONFIG_4D; 1; ($xlColonPos-1))