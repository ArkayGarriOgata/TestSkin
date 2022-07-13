//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 8/13/09
// ----------------------------------------------------
// Method: prEDI2Front
// ----------------------------------------------------

If (User in group:C338(Current user:C182; "RoleSuperUser")) | (User in group:C338(Current user:C182; "RolePlanner"))
	$id:=uProcessID("$EDI_Palette")
	If ($id#-1)
		BRING TO FRONT:C326($id)
	Else 
		$errCode:=uSpawnPalette("EDI_openPalette"; "$EDI_Palette")
		If (False:C215)
			EDI_openPalette
		End if 
	End if 
	
Else 
	uNotAuthorized
End if 