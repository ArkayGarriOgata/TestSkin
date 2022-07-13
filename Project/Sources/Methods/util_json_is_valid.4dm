//%attributes = {}
// -------
// Method: util_json_is_valid   ( ) -> true if not malformed
// By: Mel Bohince @ 06/23/17, 07:27:09
// Description
// flipped from the method below
// ----------------------------------------------------
//from: http://kb.4d.com/assetid=77784
// --------------------------------------------------------------------------------
// Name: CHECK_MALFORMED_JSON
// Description: Method will check if a JSON object construction is malformed.
// 
// Input:
// $1 (TEXT) - JSON object in text 
// 
// Output:
// $0 (BOOLEAN) - False - Not malformed, True - Is malformed
// --------------------------------------------------------------------------------
C_TEXT:C284($1; $json)
C_BOOLEAN:C305($0; $result)
C_OBJECT:C1216($obj)

If (Count parameters:C259=1)
	$json:=$1
	
	ON ERR CALL:C155("CHECK_MALFORMED_JSON")
	$obj:=JSON Parse:C1218($json)
	
	If (OB Is empty:C1297($obj)=True:C214)  //invalid
		$0:=False:C215
	Else 
		$0:=True:C214
	End if 
End if 