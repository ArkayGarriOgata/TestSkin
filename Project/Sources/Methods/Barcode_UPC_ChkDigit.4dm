//%attributes = {}
// -------
// Method: Barcode_UPC_ChkDigit   ( string) -> {string}$chkdigit
// By: Mel Bohince @ 02/14/18, 15:26:33
// Description
// return a check digit based on UPC style at https://en.wikipedia.org/wiki/Check_digit
// ----------------------------------------------------
C_LONGINT:C283($i; $sum; $chkdigit)
C_TEXT:C284($1; $0; $encode)

If (Count parameters:C259=0)  //for testing
	$encode:="01010101010"  //"03600024145"`"123456"
Else 
	$encode:=$1
End if 
$len:=Length:C16($encode)

$sum:=0
For ($i; 1; $len; 2)
	$sum:=$sum+Num:C11($encode[[$i]])
End for 
$sum:=$sum*3

For ($i; 2; $len; 2)
	$sum:=$sum+Num:C11($encode[[$i]])
End for 

$chkdigit:=10-($sum%10)

$0:=String:C10($chkdigit)