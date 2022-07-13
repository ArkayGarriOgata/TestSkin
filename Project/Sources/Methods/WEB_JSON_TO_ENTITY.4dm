//%attributes = {}
// _______
// Method: WEB_JSON_TO_ENTITY   ( ) ->
// By: Angelo @ 10/15/19, 15:38:25
// Description
// 
// ----------------------------------------------------

//WEB_JSON_TO_ENTITY
C_OBJECT:C1216($1; $obEntity; $entity; $result; $0)
C_TEXT:C284($body)
WEB GET HTTP BODY:C814($body)  // Extract HTTP Body
$entity:=$1
$obEntity:=JSON Parse:C1218($body)
$entity.fromObject($obEntity)
$result:=$entity.save()


