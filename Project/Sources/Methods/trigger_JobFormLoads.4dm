//%attributes = {}
// _______
// Method: trigger_JobFormLoads   ( ) ->
// By: Mel Bohince @ 04/30/19, 15:38:12
// Description
// 
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Job_Forms_Loads:162]LastTouched:7:=TS_ISO_String_TimeStamp
		[Job_Forms_Loads:162]ModWho:6:=util_UserGetInitials
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Job_Forms_Loads:162]LastTouched:7:=TS_ISO_String_TimeStamp
		[Job_Forms_Loads:162]ModWho:6:=util_UserGetInitials
End case 