//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/23/10, 12:27:39
// ----------------------------------------------------
// Method: x_find_saved_array(->field)
// Description
// get a selection of records from an array saved to disk
//
// Parameters
// ----------------------------------------------------
If (Count parameters:C259=0)
	$fieldPtr:=->[Customers_Projects:9]id:1
Else 
	$fieldPtr:=$1
End if 

$type_field:=Type:C295($fieldPtr->)
Case of 
	: ($type_field=Is alpha field:K8:1)
		ARRAY TEXT:C222(aAlphaKey; 0)
		util_array_load(->aAlphaKey)
		QUERY WITH ARRAY:C644($fieldPtr->; aAlphaKey)
		
	: ($type_field=Is longint:K8:6)
		ARRAY TEXT:C222(aIntegerKey; 0)
		util_array_load(->aIntegerKey)
		QUERY WITH ARRAY:C644($fieldPtr->; aIntegerKey)
End case 



