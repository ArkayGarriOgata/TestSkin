//%attributes = {"publishedWeb":true}
//PM: prQA2Front() -> 
//@author mlb - 8/20/01  15:36

$id:=uProcessID("$QA Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("QA_openPalette"; "$QA Palette")
	If (False:C215)
		QA_OpenPalette
	End if 
End if 