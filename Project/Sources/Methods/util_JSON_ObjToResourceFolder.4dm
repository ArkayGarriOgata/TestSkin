//%attributes = {}
// _______
// Method: util_JSON_ObjToResourceFolder  ( object; document name ) -> success
// By: Mel Bohince @ 04/08/21, 08:29:09
// Description
// take an object and save to resource folder
// see also util_JSON_ObjFromResourceFolder
// ----------------------------------------------------

C_OBJECT:C1216($package_o; $1)
C_TEXT:C284($documentName; $2; $package_json)
C_BOOLEAN:C305($0)

If (Count parameters:C259=2)
	$package_o:=$1
	
	$documentName:=$2
	If (Position:C15(".json"; $documentName)=0)
		$documentName:=$documentName+".json"
	End if 
	
Else   //test
	$package_o:=New object:C1471("protocol"; "afp://"; "user"; "ARKAY\\kristopher.koertge"; "password"; "chuckles"; "server"; "ark-ny-qnap")  //pwd really Charles1$
	$documentName:="config_test.json"
End if 

$package_json:=JSON Stringify:C1217($package_o; *)  //make pretty to ease hand edits later

TEXT TO DOCUMENT:C1237(Get 4D folder:C485(Current resources folder:K5:16)+$documentName; $package_json)
If (ok=1)
	$0:=True:C214
Else 
	$0:=False:C215
End if 
