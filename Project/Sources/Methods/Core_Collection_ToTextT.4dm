//%attributes = {}
//Method:  Core_Collection_ToTextT(cValue)=>tValue
//Description:  This method will take a collection and return it as a text

If (True:C214)
	
	C_COLLECTION:C1488($1; $cValue)
	
	C_TEXT:C284($0; $tValue)
	
	ARRAY TEXT:C222($atValue; 0)
	
	$cValue:=$1
	$tValue:=CorektBlank
	
End if 

COLLECTION TO ARRAY:C1562($cValue; $atValue)

$tValue:=Core_Array_ToTextT(->$atValue; CorektDoubleQuote+CorektSemiColon+CorektDoubleQuote)

$0:=$tValue