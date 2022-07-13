//%attributes = {}
// _______
// Method: WEB_SEND_ENTITY   ( ) ->
// By: Angelo @ 10/15/19, 15:35:57
// Description
// 
// ----------------------------------------------------

//WEB_SEND_ENTITY

C_OBJECT:C1216($1; $entity)
C_TEXT:C284($attribs; $2)

$entity:=$1

If (Count parameters:C259=2)
	$attribs:=$2  // list of attributes to send
End if 

$obVars:=WEB_Get_Vars
$rel_1:=$obVars.rel_1  // Get related attributes through the N to 1 relation
$rel_N:=$obVars.rel_N  // Get related attributes through the 1 to N relation
$rel_N_1:=$obVars.rel_N_1  // Get related attributes through the 1 to N to 1 relation

$filter:=$attribs

If ($rel_1#Null:C1517)
	$filter:=$filter+","+$rel_1+".*"
End if 

If ($rel_N#Null:C1517)
	$filter:=$filter+","+$rel_N+".*"
End if 

If ($rel_N_1#Null:C1517)
	$filter:=$filter+","+$rel_N+"."+$rel_N_1+".*"
End if 

$json:=JSON Stringify:C1217($entity.toObject($filter; dk with primary key:K85:6); *)
WEB SEND TEXT:C677($json; "application/json")
