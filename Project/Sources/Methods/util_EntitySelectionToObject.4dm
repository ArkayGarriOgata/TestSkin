//%attributes = {}
// _______
// Method: util_EntitySelectionToObject   ( ) -> object with an array property of record numbers
// By: Mel Bohince @ 12/12/20, 18:14:58
// Description
// change an entity selection to an object that can be passed to another process (on server)
// reconstitute with util_EntitySelectionFromObject
// ----------------------------------------------------
// Modified by: Mel Bohince (6/9/21)test for null entity seleciton

C_OBJECT:C1216($entitySelection; $1; $entityObject; $0)
C_POINTER:C301($2; $table_ptr)
ARRAY LONGINT:C221($_recordNumbers; 0)

If (Count parameters:C259=2)
	$entitySelection:=$1
	$table_ptr:=$2
Else   //test
	$entitySelection:=ds:C1482.Customers.all()
	$table_ptr:=->[Customers:16]
End if 

If ($entitySelection#Null:C1517)  // Modified by: Mel Bohince (6/9/21) 
	USE ENTITY SELECTION:C1513($entitySelection)
Else 
	REDUCE SELECTION:C351($table_ptr->; 0)
End if 

LONGINT ARRAY FROM SELECTION:C647($table_ptr->; $_recordNumbers)
REDUCE SELECTION:C351($table_ptr->; 0)
OB SET ARRAY:C1227($entityObject; "recordNumbers"; $_recordNumbers)

$0:=$entityObject
