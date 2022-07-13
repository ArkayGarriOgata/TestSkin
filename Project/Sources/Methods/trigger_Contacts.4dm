//%attributes = {}
// _______
// Method: trigger_Contacts   ( ) ->
// By: Mel Bohince @ 04/20/20, 10:53:36
// Description
// 
// ----------------------------------------------------


C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Contacts:51]ContactID:1:=app_set_id_as_string(Table:C252(->[Contacts:51]))
		[Contacts:51]ModDate:19:=4D_Current_date
		[Contacts:51]ModWho:20:=User_GetInitials
		[Contacts:51]Active:12:=True:C214
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Contacts:51]ModDate:19:=4D_Current_date
		[Contacts:51]ModWho:20:=User_GetInitials
End case 