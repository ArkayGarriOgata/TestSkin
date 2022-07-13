//%attributes = {}
// Method: Barcode_128weightFnc1 () -> 
// ----------------------------------------------------
// by: mel: 12/21/04, 18:33:26
// ----------------------------------------------------

C_TEXT:C284($1; $fnc1Char)  //char to test
C_LONGINT:C283($2; $positionInString; $thisWeight; $0; $fnc1; $fnc1value)

$char:=$1
$fnc1:=util_ConvertAscii(202)
$fnc1Char:=Char:C90($fnc1)
$fnc1value:=Barcode_128aGetValue($fnc1)
$positionInString:=$2
$thisWeight:=0

If ($char=$fnc1Char)
	$thisWeight:=$positionInString*$fnc1value
End if 

$0:=$thisWeight