//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/03/06, 15:41:36
// ----------------------------------------------------
// Method: app_getNextID(table_number;->$server;->nextId)-->bool:success
// Description
// return the server designation and the next sequence number
// see also app_set_id_as_string
// ----------------------------------------------------

C_LONGINT:C283($tableNumber; $1)
C_POINTER:C301($serverDesignationPtr; $2; $idNumberPtr; $3)
C_BOOLEAN:C305($0)  //success or failure

$tableNumber:=$1
$serverDesignationPtr:=$2
$idNumberPtr:=$3

READ WRITE:C146([x_id_numbers:3])
QUERY:C277([x_id_numbers:3]; [x_id_numbers:3]Table_Number:1=$tableNumber)
If (Records in selection:C76([x_id_numbers:3])#1)
	CREATE RECORD:C68([x_id_numbers:3])
	[x_id_numbers:3]Table_Number:1:=$tableNumber
	[x_id_numbers:3]ID_No:2:=0
	[x_id_numbers:3]ServerDesignation:7:=<>SERVER_DESIGNATION
	SAVE RECORD:C53([x_id_numbers:3])
End if 

If (fLockNLoad(->[x_id_numbers:3]))
	$serverDesignationPtr->:=[x_id_numbers:3]ServerDesignation:7
	$idNumberPtr->:=[x_id_numbers:3]ID_No:2+[x_id_numbers:3]Seq_Offset:3
	[x_id_numbers:3]ID_No:2:=[x_id_numbers:3]ID_No:2+1
	SAVE RECORD:C53([x_id_numbers:3])
	$0:=True:C214
	
Else 
	BEEP:C151
	ALERT:C41("Next ID_NUMBER process  "+String:C10($tableNumber)+" stopped by user")
	$serverDesignationPtr->:="?"
	$idNumberPtr->:=No current record:K29:2
	$0:=False:C215
End if 

UNLOAD RECORD:C212([x_id_numbers:3])
READ ONLY:C145([x_id_numbers:3])