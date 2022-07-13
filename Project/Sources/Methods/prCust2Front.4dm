//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prCust2Front
// ----------------------------------------------------

$id:=uProcessID("$Customers Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("gCustEvent"; "$Customers Palette")
	If (False:C215)
		gCustEvent
	End if 
End if 