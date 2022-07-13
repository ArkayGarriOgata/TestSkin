//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_GetLoginPort - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($ttURI)
C_LONGINT:C283($xlAtPos; $xlColonPos; $xlSlashPos)

$xlAtPos:=Position:C15(Char:C90(At sign:K15:46); <>ttWMS_CONFIG_4D)

$ttURI:=Substring:C12(<>ttWMS_CONFIG_4D; ($xlAtPos+1))

$xlColonPos:=Position:C15(":"; $ttURI)
$xlSlashPos:=Position:C15("/"; $ttURI)

$0:=Substring:C12($ttURI; ($xlColonPos+1); ($xlSlashPos-$xlColonPos-1))