//%attributes = {}
// _______
// Method: WEB_RESP_JSON   ( ) ->
// By: Angelo @ 10/15/19, 15:37:53
// Description
// 
// ----------------------------------------------------

//WEB_RESP_JSON
//Send a JSON response
//{"result";"RESPONSE"}

C_TEXT:C284($1; $json)
C_LONGINT:C283($2)
C_OBJECT:C1216($obResp)
$obResp:=New object:C1471("result"; $1; "code"; 1)

If (Count parameters:C259=2)
	$obResp.code:=$2
End if 

$json:=JSON Stringify:C1217($obResp; *)
WEB SEND TEXT:C677($json; "application/json")
