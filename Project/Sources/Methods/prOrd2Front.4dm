//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: prOrd2Front
// ----------------------------------------------------

$id:=uProcessID("$Customers' Order Palette")

If ($id#-1)
	BRING TO FRONT:C326($id)
Else 
	$errCode:=uSpawnPalette("gCustOrdEvent"; "$Customers' Order Palette")
	If (False:C215)
		gCustOrdEvent
	End if 
End if 