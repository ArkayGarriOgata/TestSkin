//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/30/08, 10:56:53
// ----------------------------------------------------
// Method: TriggerMessage_NoErrors
// Description
// test if there are any error in the queue
// opposite of TriggerMessage_HasErrors
// ----------------------------------------------------

LOAD RECORD:C52([z_TriggerMessage:148])

If (Length:C16([z_TriggerMessage:148]Message:3)=0)
	$0:=True:C214
Else 
	$0:=False:C215
End if 