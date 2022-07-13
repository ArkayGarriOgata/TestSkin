//%attributes = {}
// -------
// Method: util_textToArray_explode   (->text;delimiter;->array ) -> num elements
// By: Mel Bohince @ 05/24/18, 12:13:40
// Description put a delimited string into an array
// see also util_textFromArray_implode
// ----------------------------------------------------

C_LONGINT:C283($char)
C_TEXT:C284($source; $delim; $element)
C_POINTER:C301($1; $3)

If (Count parameters:C259=3)
	$source:=$1->
	$delim:=$2
	$ptrArray:=$3
Else   //test
	$source:="abc, 1,2, jack ass"
	$delim:=","
	ARRAY TEXT:C222($testArray; 0)
	$ptrArray:=->$testArray
End if 
ARRAY TEXT:C222($ptrArray->; 0)

$element:=""

For ($char; 1; Length:C16($source))
	If ($source[[$char]]=$delim)
		APPEND TO ARRAY:C911($ptrArray->; $element)
		$element:=""
	Else 
		$element:=$element+$source[[$char]]
	End if 
End for 

If (Length:C16($element)>0)
	APPEND TO ARRAY:C911($ptrArray->; $element)
	$element:=""
End if 


$0:=Size of array:C274($ptrArray->)

