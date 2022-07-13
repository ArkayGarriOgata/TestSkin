//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_GetLoginPassword - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($xlColonPos; $xlAtPos)

$xlColonPos:=Position:C15(":"; <>ttWMS_CONFIG_4D)
$xlAtPos:=Position:C15(Char:C90(At sign:K15:46); <>ttWMS_CONFIG_4D)
$0:=Substring:C12(<>ttWMS_CONFIG_4D; ($xlColonPos+1); ($xlAtPos-$xlColonPos-1))
