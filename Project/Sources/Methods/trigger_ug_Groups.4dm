//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 10:33:44
// ----------------------------------------------------
// Method: trigger_ug_Groups()  --> 
// ----------------------------------------------------

If (Trigger event:C369=On Deleting Record Event:K3:3)
	RELATE MANY:C262([ug_Groups:140]groupID:1)
	DELETE SELECTION:C66([ug_UsersInGroups:142])
End if 