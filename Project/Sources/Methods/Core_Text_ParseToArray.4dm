//%attributes = {}
//Method:  Core_Text_ParseToArray(tWords;patWord;tSeparator)
//Description:  This method parses text to array

If (True:C214)  //Initializing
	
	C_TEXT:C284($1; $tWords; $3; $tSeparator)
	C_POINTER:C301($2; $patWord)
	
	C_COLLECTION:C1488($cWord)
	
	$tWords:=$1
	$patWord:=$2
	$tSeparator:=$3
	
	$cWord:=New collection:C1472()
	
End if   //Done initializing

$cWord:=Split string:C1554($tWords; $tSeparator; sk ignore empty strings:K86:1+sk trim spaces:K86:2)

COLLECTION TO ARRAY:C1562($cWord; $patWord->)
