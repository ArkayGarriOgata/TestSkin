//%attributes = {}
// Method: Barcode_128interleaveGetCode ($dataToEncode;$position) -> $codeCrepresentation
// ----------------------------------------------------
// by: mel: 12/21/04, 18:50:46
// ----------------------------------------------------
// Description:
// convert a pair to a number code
//this can be used to make 1 character out of 2 numbers
//pass this value to get weight
// ----------------------------------------------------

C_LONGINT:C283($2; $0)  //$codeCrepresentation
C_TEXT:C284($1)

//C_TEXT($pair)
//$pair:=Substring($1;$2;2)  `grab to characters
//$codeCrepresentation:=Num($pair)  `convert to integer
$0:=Num:C11(Substring:C12($1; $2; 2))  //convert to integer