//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/30/08, 10:43:16
// ----------------------------------------------------
// Method: TriggerMessage_Set(error#;msg)
// Description
// set a message in the queue if there was an error
// see also TriggerMessage("set-message")
// ----------------------------------------------------

C_LONGINT:C283($0; $1)
C_TEXT:C284($2)

If ($1#0)
	LOAD RECORD:C52([z_TriggerMessage:148])
	[z_TriggerMessage:148]Message:3:=TS2String(TSTimeStamp)+": "+$2+Char:C90(13)+[z_TriggerMessage:148]Message:3
	SAVE RECORD:C53([z_TriggerMessage:148])
	$0:=$1
End if 
$0:=$1  //return the error number back