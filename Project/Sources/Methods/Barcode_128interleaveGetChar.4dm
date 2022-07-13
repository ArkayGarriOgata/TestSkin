//%attributes = {}
// Method: Barcode_128interleaveGetChar ($codeCrepresentation) -> char to print
// ----------------------------------------------------
// by: mel: 12/21/04, 18:45:39
// ----------------------------------------------------

C_LONGINT:C283($1; $codeCrepresentation)
C_TEXT:C284($0)

$codeCrepresentation:=$1
Case of 
	: ($codeCrepresentation=0)  //special rule for zero
		$0:=Char:C90(util_ConvertAscii(159))
	: ($codeCrepresentation<95)  //add to 32 to obtain ascii representation
		$0:=Char:C90(util_ConvertAscii($codeCrepresentation+32))
	Else   //add to 100 to obtain ascii representation
		$0:=Char:C90(util_ConvertAscii($codeCrepresentation+100))
End case 