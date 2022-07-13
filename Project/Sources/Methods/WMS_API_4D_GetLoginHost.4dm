//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_GetLoginHost - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($ttURI)
C_LONGINT:C283($xlAtPos; $xlColPos)

$xlAtPos:=Position:C15(Char:C90(At sign:K15:46); <>ttWMS_CONFIG_4D)
$ttURI:=Substring:C12(<>ttWMS_CONFIG_4D; 1+$xlAtPos)
$xlColPos:=Position:C15(":"; $ttURI)

$0:=Substring:C12($ttURI; 1; $xlColPos-1)
