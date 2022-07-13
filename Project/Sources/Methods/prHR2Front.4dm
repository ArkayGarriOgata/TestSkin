//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/06/05, 14:29:26
// ----------------------------------------------------
// Method: prHR2Front
// ----------------------------------------------------

If (Current user:C182="Designer") | (User in group:C338(Current user:C182; "RolePayRoll"))
	$id:=uProcessID("$HR_Palette")
	If ($id#-1)
		BRING TO FRONT:C326($id)
	Else 
		$errCode:=uSpawnPalette("HR_openPalette"; "$HR_Palette")
		If (False:C215)
			HR_openPalette
		End if 
	End if 
	
Else 
	uNotAuthorized
End if 