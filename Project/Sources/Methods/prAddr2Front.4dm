//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prAddr2Front
// ----------------------------------------------------

$id:=uProcessID("$Address Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("gCaddEvent"; "$Address Palette")
	If (False:C215)
		gCaddEvent
	End if 
End if 