//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prRM2Front
// ----------------------------------------------------

$id:=uProcessID("$Raw Material Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("RM_OpenPalette"; "$Raw Material Palette")
	If (False:C215)
		RM_OpenPalette
	End if 
End if 