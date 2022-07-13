//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prCC2Front
// ----------------------------------------------------

$id:=uProcessID("$Standards Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("gCCEvent"; "$Standards Palette")
	If (False:C215)
		gCCEvent
	End if 
End if 