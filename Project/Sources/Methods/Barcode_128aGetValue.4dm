//%attributes = {}
// Method: Barcode_128aGetValue (ascii(char)) -> $charValue
// ----------------------------------------------------
// by: mel: 12/27/04, 10:15:58
// ----------------------------------------------------
// Description:
// return the value to use in the weighted chk digit calcualtion,
// given an ascii code.
// ----------------------------------------------------

C_LONGINT:C283($1; $0; $winChar)

$winChar:=util_ConvertAscii(0; $1)

Case of 
	: ($winChar=194)
		$0:=0
	: ($winChar>126)
		$0:=($winChar-100)  //100 is the offset between value and ascii number of specials
	Else 
		$0:=($winChar-32)  //32 is the offset between value and ascii number
End case 