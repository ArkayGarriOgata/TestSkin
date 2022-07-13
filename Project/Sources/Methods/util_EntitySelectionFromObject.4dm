//%attributes = {}
// _______
// Method: util_EntitySelectionFromObject   ( ) ->  entity selection
// By: Mel Bohince @ 12/12/20, 18:35:03
// Description
// reconstitute an entity selection that had be saved in a array within an object 
// by method util_EntitySelectionToObject so that it could be passed as a argument
// ----------------------------------------------------
// Modified by: Mel Bohince (6/9/21) test for null collection

C_OBJECT:C1216($entitySelection; $1; $entityObject; $0)
C_POINTER:C301($2; $table_ptr)
ARRAY LONGINT:C221($_recordNumbers; 0)

If (Count parameters:C259=2)
	$entityObject:=$1
	$table_ptr:=$2
Else   //test
	$entityObject:=util_EntitySelectionToObject(ds:C1482.Customers.all(); ->[Customers:16])
	$table_ptr:=->[Customers:16]
End if 

If ($entityObject#Null:C1517)  // Modified by: Mel Bohince (6/9/21) 
	COLLECTION TO ARRAY:C1562($entityObject.recordNumbers; $_recordNumbers)  //OB GET ARRAY ( $entityObject ; "recordNumbers" ; $_recordNumbers )  //does it matter?
End if 

CREATE SELECTION FROM ARRAY:C640($table_ptr->; $_recordNumbers)
$entitySelection:=Create entity selection:C1512($table_ptr->)
REDUCE SELECTION:C351($table_ptr->; 0)

$0:=$entitySelection
