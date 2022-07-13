//%attributes = {}

// Method: prWMS2Front ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/06/15, 08:34:57
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------
// Modified by: Mel Bohince (4/3/16) increase process memory for web area

If (User in group:C338(Current user:C182; "RoleSuperUser")) | (User in group:C338(Current user:C182; "RoleMaterialHandler"))
	$id:=uProcessID("$WMS_Palette")
	If ($id#-1)
		BRING TO FRONT:C326($id)
	Else 
		$errCode:=uSpawnPalette("WMS_openPalette"; "$WMS_Palette"; <>lMidMemPart)
		If (False:C215)
			WMS_openPalette
		End if 
	End if 
	
Else 
	uNotAuthorized
End if 