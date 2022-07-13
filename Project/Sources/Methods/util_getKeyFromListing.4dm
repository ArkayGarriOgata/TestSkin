//%attributes = {"publishedWeb":true}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: util_getKeyFromListing - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 



//PM: util_getKeyFromListing(->fieldKey) -> string10
//see also util_getKeyFromListingNumber
//@author mlb - 5/10/02  10:43
C_POINTER:C301($1; $fieldPtr; $tablePtr)
C_TEXT:C284($0)
$fieldPtr:=$1
$tablePtr:=Table:C252(Table:C252($fieldPtr))


CUT NAMED SELECTION:C334($tablePtr->; "getKeyFromListing")
USE SET:C118("UserSet")
ONE RECORD SELECT:C189($tablePtr->)
$0:=$fieldPtr->
USE NAMED SELECTION:C332("getKeyFromListing")

HIGHLIGHT RECORDS:C656($tablePtr->; "UserSet")  //v1.0.0-PJK (12/22/15) reselect records
//