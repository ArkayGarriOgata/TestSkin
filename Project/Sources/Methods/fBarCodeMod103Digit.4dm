//%attributes = {"publishedWeb":true}
//PM:  fBarCodeMod103Digit  10/26/00  mlb
//return the Modulo 103 check character of a string

C_TEXT:C284($1; $dataToEncode)  //data To encode
C_TEXT:C284($0)
C_LONGINT:C283($weightedTotal; $position; $char; $value; $weightedTotal; $chkDigitValue)

$dataToEncode:=Substring:C12($1; 1; 20)
$weightedTotal:=102+105  //value of the startC and fnc1

For ($position; 1; Length:C16($dataToEncode))
	$char:=Character code:C91($dataToEncode[[$position]])-32
	$value:=$char*($position+1)
	$weightedTotal:=$weightedTotal+$value
End for 
$chkDigitValue:=($weightedTotal%103)+32

$0:=Char:C90($chkDigitValue)