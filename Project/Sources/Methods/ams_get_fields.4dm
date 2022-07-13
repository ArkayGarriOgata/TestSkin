//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 10/29/10, 14:07:31
// ----------------------------------------------------
// Method: ams_get_fields
// ----------------------------------------------------

C_LONGINT:C283($1)  //table number
ARRAY TEXT:C222(aFieldNames; 0)
//ARRAY TEXT(aFieldNames;$numFields)

$numFields:=Get last field number:C255($1)
ARRAY TEXT:C222(aFieldNames; $numFields)

For ($i; 1; $numFields)
	aFieldNames{$i}:=Field name:C257($1; $i)
End for 
SORT ARRAY:C229(aFieldNames; >)