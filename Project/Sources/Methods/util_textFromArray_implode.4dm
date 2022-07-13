//%attributes = {}
// ----------------------------------------------------
// Method: util_textFromArray_implode   (->textArray{;delim} ) -> text
// By: Mel Bohince @ 05/06/16, 09:09:49
// Description
// flatten an array to text
// see also util_textToArray_explode
// ----------------------------------------------------
C_POINTER:C301($1; $theArray)
C_TEXT:C284($rtn; $0; $2; $delim)
C_LONGINT:C283($element)

$theArray:=$1

If (Count parameters:C259>1)
	$delim:=$2
Else 
	$delim:=" "
End if 

$rtn:=""

For ($element; 1; Size of array:C274($theArray->))
	$rtn:=$rtn+$theArray->{$element}+$delim
End for 

$rtn:=Substring:C12($rtn; 1; (Length:C16($rtn)-Length:C16($delim)))

$0:=$rtn
