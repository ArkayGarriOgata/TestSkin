//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prPO2Front
// ----------------------------------------------------

$id:=uProcessID("$Purchasing Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("PO_OpenPalette"; "$Purchasing Palette")
End if 