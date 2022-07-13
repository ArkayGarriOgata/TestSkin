//%attributes = {"publishedWeb":true}
//(P) nZeroFill -> string: Left fills with zeros up to specified number
//Example: var:=nZeroFill("A";3) -> "00A"

C_TEXT:C284($0; $1)  //Return and passed strings
C_LONGINT:C283($2)  //number of spaces to fill with zeros

$0:=("0"*($2-Length:C16($1)))+$1