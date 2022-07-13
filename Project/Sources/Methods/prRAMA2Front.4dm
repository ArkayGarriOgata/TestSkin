//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/10/12, 14:29:12
// ----------------------------------------------------
// Method: prRAMA2Front
// ----------------------------------------------------

$id:=uProcessID("Rama Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("Rama_OpenPalette"; "Rama Palette")
	If (False:C215)
		Rama_OpenPalette
	End if 
End if 