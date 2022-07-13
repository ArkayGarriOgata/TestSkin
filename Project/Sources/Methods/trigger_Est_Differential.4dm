//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/31/06, 15:08:40
// ----------------------------------------------------
// Method: trigger_Est_Differential
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1) | (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Estimates_Differentials:38]ModDate:44:=4D_Current_date
		[Estimates_Differentials:38]ModWho:43:=User_GetInitials
End case 