//%attributes = {}
// _______
// Method: API_SAVE_TABLES   ( ) ->
// By: Angelo @ 10/15/19, 15:26:24
// Description
// 
// ----------------------------------------------------

C_COLLECTION:C1488($1)
$json:=JSON Stringify:C1217($1; *)
$jsonPath:=Get 4D folder:C485(Database folder:K5:14; *)+"params"+Folder separator:K24:12+"tables.json"
CREATE FOLDER:C475($jsonPath; *)
TEXT TO DOCUMENT:C1237($jsonPath; $json; "UTF-8"; Document with LF:K24:22)

