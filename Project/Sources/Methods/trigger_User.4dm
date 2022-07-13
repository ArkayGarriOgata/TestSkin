//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/27/05, 12:00:18
// ----------------------------------------------------
// Method: trigger_User
// ----------------------------------------------------

C_LONGINT:C283($0)

$0:=0  //assume granted

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1) | (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Users:5]hasSignature:58:=Picture size:C356([Users:5]Signature:13)
End case 