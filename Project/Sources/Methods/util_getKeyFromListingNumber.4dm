//%attributes = {}
//PM: util_getKeyFromListingNumber(->fieldKey) -> string10
//see also util_getKeyFromListing
//@author mlb - 5/10/02  10:43
C_POINTER:C301($1; $fieldPtr; $tablePtr)
C_LONGINT:C283($0)
$fieldPtr:=$1
$tablePtr:=Table:C252(Table:C252($fieldPtr))

CUT NAMED SELECTION:C334($tablePtr->; "getKeyFromListing")
USE SET:C118("UserSet")
ONE RECORD SELECT:C189($tablePtr->)
$0:=$fieldPtr->
USE NAMED SELECTION:C332("getKeyFromListing")
//