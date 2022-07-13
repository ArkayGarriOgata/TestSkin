//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/08/08, 16:43:02
// ----------------------------------------------------
// Method: TriggerMessage_HasErrors
// Description
// opposite of TriggerMessage_NoErrors
// ----------------------------------------------------

LOAD RECORD:C52([z_TriggerMessage:148])
If (Length:C16([z_TriggerMessage:148]Message:3)#0)
	$0:=True:C214
Else 
	$0:=False:C215
End if 