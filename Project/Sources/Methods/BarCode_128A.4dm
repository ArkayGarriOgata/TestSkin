//%attributes = {}
// Method: BarCode_128A (application code;data{;application code;data}) -> encoded text value
// ----------------------------------------------------
// by: mel: 11/29/04, 16:25:56
// ----------------------------------------------------
// Description:
// encode a pair of applicationcode/data combo's into Code128setA
// note, make sure data arguement is uppercase since Set A is being used;
// otherwise the lower case is treated as control characters
// ----------------------------------------------------

C_TEXT:C284($1; $2; $0; $data)
C_LONGINT:C283($position; $startCode_A; $fnc1; $stopCode)
C_TEXT:C284($chkChar)

$startCode_A:=util_ConvertAscii(203)  //$startCode_Avalue:=103
$fnc1:=util_ConvertAscii(202)  //$fnc1value:=102
$stopCode:=util_ConvertAscii(206)  //don't encode

If (Count parameters:C259>=1)
	$firstSymbol:=$1
	$dataToEncode:=Char:C90($fnc1)+$firstSymbol
End if 

If (Count parameters:C259>=2)
	$secondSymbol:=$2
	$dataToEncode:=$dataToEncode+Char:C90($fnc1)+$secondSymbol
End if 

$weightedTotal:=Barcode_128aGetValue($startCode_A)  //primer, don't use position of start char

For ($position; 1; Length:C16($dataToEncode))
	$charValue:=Barcode_128aGetValue(Character code:C91($dataToEncode[[$position]]))*$position
	$weightedTotal:=$weightedTotal+$charValue
End for 

$chkChar:=Barcode_128getChkDigit($weightedTotal)  //mod103

$0:=Char:C90($startCode_A)+$dataToEncode+$chkChar+Char:C90($stopCode)