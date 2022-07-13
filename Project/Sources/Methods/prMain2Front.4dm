//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prMain2Front
// ----------------------------------------------------

$id:=uProcessID("$Main Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("mMainEvent"; "$Main Palette")
	If (False:C215)
		mMainEvent
	End if 
End if 