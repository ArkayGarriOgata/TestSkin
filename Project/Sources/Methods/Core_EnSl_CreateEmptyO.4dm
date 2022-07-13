//%attributes = {}
//Method:  Core_EnSl_CreateEmptyO(pTable)=>esEmpty
//Description:  This method will create an empty entity selection

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pTable)
	C_OBJECT:C1216($0; $esEmpty)
	
	$pTable:=$1
	
	$esEmpty:=New object:C1471()
	
End if   //Done initialize

CREATE EMPTY SET:C140($pTable->; "EmptySet")

USE SET:C118("EmptySet")

$esEmpty:=Create entity selection:C1512($pTable->)

$0:=$esEmpty