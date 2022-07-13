//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/08/06, 13:43:19
// ----------------------------------------------------
// Method: app_AutoIncrement(->ptr:Table)-->unique longint for that table
// Description
// prepare to sunset "Sequence Number" command.
// ----------------------------------------------------

C_POINTER:C301($tablePtr; $1)
C_LONGINT:C283($tableNumber; $offset; $0; $nextID)
C_TEXT:C284($server)

$tablePtr:=$1
$tableNumber:=Table:C252($tablePtr)

$server:="?"
$nextID:=-3
If (app_getNextID($tableNumber; ->$server; ->$nextId))
	$0:=$nextID
Else 
	$0:=-1
	CANCEL:C270
End if 