//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prReq2Front
// ----------------------------------------------------

$id:=uProcessID("$Requistion Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("gReqEvent"; "$Requistion Palette")
	If (False:C215)
		gReqEvent
	End if 
End if 