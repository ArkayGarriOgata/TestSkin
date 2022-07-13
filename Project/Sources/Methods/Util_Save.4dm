//%attributes = {}
//Method: Util_UniqueRecord(pTable)
//Descprition:  This method will make sure that a unique record is ready
// to be modified or created for table

C_POINTER:C301($1; $pTable)

$pTable:=$1

SAVE RECORD:C53($pTable->)
UNLOAD RECORD:C212($pTable->)
READ ONLY:C145($pTable->)
