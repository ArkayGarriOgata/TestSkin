//%attributes = {}

//$1=Line to parse
// Assumes tab delimited text

C_TEXT:C284($1; $ttLine)
$ttLine:=$1

ARRAY TEXT:C222(sttImportFields; 0)

While (Length:C16($ttLine)>0)
	$ttField:=GetNextField(->$ttLine; Char:C90(9))
	APPEND TO ARRAY:C911(sttImportFields; $ttField)
End while 
