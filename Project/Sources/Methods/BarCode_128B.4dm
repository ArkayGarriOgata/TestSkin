//%attributes = {}
// Method: BarCode_128B () -> 
// ----------------------------------------------------
// by: mel: 12/27/04, 11:48:24
// ----------------------------------------------------
// Description:
// encode a pair of applicationcode/data combo's into Code128setB
// ----------------------------------------------------

C_TEXT:C284($1; $2; $0; $data)
C_LONGINT:C283($position; $startCode_B; $fnc1; $stopCode)
$startCode_B:=util_ConvertAscii(204)  //$startCode_Bvalue:=104
$fnc1:=util_ConvertAscii(202)  //$fnc1value:=102
$stopCode:=util_ConvertAscii(206)  //don't encode
C_TEXT:C284($chkChar)

If (Count parameters:C259>=1)
	$firstSymbol:=$1
	$dataToEncode:=Char:C90($fnc1)+$firstSymbol
End if 

If (Count parameters:C259>=2)
	$secondSymbol:=$2
	$dataToEncode:=$dataToEncode+Char:C90($fnc1)+$secondSymbol
End if 

$weightedTotal:=Barcode_128aGetValue($startCode_B)  //primer, don't use position of start char

For ($position; 1; Length:C16($dataToEncode))
	$charValue:=Barcode_128aGetValue(Character code:C91($dataToEncode[[$position]]))*$position
	$weightedTotal:=$weightedTotal+$charValue
End for 

$chkChar:=Barcode_128getChkDigit($weightedTotal)  //mod103

$0:=Char:C90($startCode_B)+$dataToEncode+$chkChar+Char:C90($stopCode)