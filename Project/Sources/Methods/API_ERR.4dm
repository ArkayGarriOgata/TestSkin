//%attributes = {}
// _______
// Method: API_ERR   ( ) ->
// By: Mel Bohince @ 10/17/19, 10:32:34
// Description
// 
// ----------------------------------------------------



C_COLLECTION:C1488($colError)
ARRAY LONGINT:C221($errCodes; 0)
ARRAY TEXT:C222($comps; 0)
ARRAY TEXT:C222($errMsgs; 0)

GET LAST ERROR STACK:C1015($errCodes; $comps; $errMsgs)

$colError:=New collection:C1472
ARRAY TO COLLECTION:C1563($colError; $errCodes; "errorCodes"; $comps; "components"; $errMsgs; "errorMessages")
$json:=JSON Stringify:C1217($colError; *)
WEB SEND TEXT:C677($json; "application/json")
ABORT:C156
