//%attributes = {}
// _______
// Method: util_JSON_ObjFromResourceFolder   (json document in resource folder ) -> 4D object
// By: Mel Bohince @ 04/08/21, 08:49:54
// Description
// return a 4D object from a json file in the resource folder
// see also util_JSON_ObjToResourceFolder
// ----------------------------------------------------

C_OBJECT:C1216($package_o; $0)
C_TEXT:C284($documentName; $1; $documentPath; $package_json)

If (Count parameters:C259=1)
	$documentName:=$1
	If (Position:C15(".json"; $documentName)=0)
		$documentName:=$documentName+".json"
	End if 
	
Else 
	$documentName:="config_test.json"
End if 


$documentPath:=Get 4D folder:C485(Current resources folder:K5:16)+$documentName
If (Test path name:C476($documentPath)=Is a document:K24:1)
	
	ON ERR CALL:C155("e_EmptyErrorMethod")  //Doc 2 text can throw error, suppress and return null 
	
	$package_json:=Document to text:C1236($documentPath)
	If (Length:C16($package_json)>2)  //at least {}, calling method needs to test
		$package_o:=JSON Parse:C1218($package_json)
		//need JSON Validate, but don't understand schema param
		
	Else 
		$package_o:=Null:C1517
	End if 
	
	ON ERR CALL:C155("")
	
Else   //doc doesn't exist
	$package_o:=Null:C1517
End if 

$0:=$package_o
