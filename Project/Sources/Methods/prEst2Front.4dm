//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prEst2Front
// ----------------------------------------------------

$id:=uProcessID("$Estimating Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("ESTIMATE_OpenPalette"; "$Estimating Palette")
	If (False:C215)
		ESTIMATE_OpenPalette
	End if 
End if 