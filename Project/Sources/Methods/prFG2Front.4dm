//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prFG2Front
// ----------------------------------------------------

$id:=uProcessID("$Finished Goods Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("FG_OpenPalette"; "$Finished Goods Palette")
	If (False:C215)
		FG_OpenPalette
	End if 
End if 