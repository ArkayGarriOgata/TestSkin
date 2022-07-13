//%attributes = {}
// Method: Barcode_128getChkDigit (weightedValue) -> checkdigit character
// ----------------------------------------------------
// by: mel: 12/21/04, 18:28:40
// ----------------------------------------------------
// Description:
// return a character representing the mod103 check digit value
// ----------------------------------------------------

C_LONGINT:C283($1; $weightedTotal; $chkDigitValue)  //weighted value 
C_TEXT:C284($0)

$weightedTotal:=$1
$chkDigitValue:=$weightedTotal%103  //get the remainder

Case of   //get ascii representation of check digit
	: ($chkDigitValue=0)
		$chkDigitValue:=159
	: ($chkDigitValue<95)
		$chkDigitValue:=$chkDigitValue+32
	Else 
		$chkDigitValue:=$chkDigitValue+100
End case 

//$0:=Char($chkDigitValue)
$0:=Char:C90(util_ConvertAscii($chkDigitValue))