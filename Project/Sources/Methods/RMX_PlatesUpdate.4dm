//%attributes = {}
// -------
// Method: RMX_PlatesUpdate   ( ) ->
// By: Mel Bohince @ 12/06/17, 15:53:43
// Description
// 
// ----------------------------------------------------
// update would haveto change rmx issue, so just review for now
//
If (User in group:C338(Current user:C182; "RoleLineManager"))
	ViewSetter(2; ->[Job_PlatingMaterialUsage:175])
	
Else 
	ViewSetter(3; ->[Job_PlatingMaterialUsage:175])
End if 