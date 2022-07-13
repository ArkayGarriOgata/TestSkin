//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prJob2Front
// ----------------------------------------------------

$id:=uProcessID("$Jobs Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("JOB_OpenPalette"; "$Jobs Palette")
	If (False:C215)
		JOB_OpenPalette
	End if 
End if 