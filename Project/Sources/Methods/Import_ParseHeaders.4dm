//%attributes = {}

//$1=Line to parse
// Assumes tab delimited text

C_TEXT:C284($1; $ttLine)
$ttLine:=$1

ARRAY TEXT:C222(sttImportHeaders; 0)

While (Length:C16($ttLine)>0)
	$ttField:=StripChars(GetNextField(->$ttLine; Char:C90(9)); " ")
	APPEND TO ARRAY:C911(sttImportHeaders; $ttField)
End while 