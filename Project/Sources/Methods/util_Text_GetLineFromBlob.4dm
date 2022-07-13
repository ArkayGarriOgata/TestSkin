//%attributes = {}
// Method: util_Text_GetLineFromBlob
//former:  zText_GetLineFromBlob  090502  mlb
//return a line of a blob upto and includeing delimiter
C_POINTER:C301($blob; $1; $returnPtr; $4)
C_LONGINT:C283($position; $2; $charNumber; $0; $delimitor)
$blob:=$1
$max:=BLOB size:C605($blob->)
$position:=$2  //start at
$delimitor:=$3
$returnPtr:=$4
$charNumber:=$blob->{$position}
While ($charNumber#$delimitor) & ($position<($max-1))
	$returnPtr->:=$returnPtr->+Char:C90($charNumber)
	$position:=$position+1
	$charNumber:=$blob->{$position}
End while 

//If ($charNumber=$delimitor)
$returnPtr->:=$returnPtr->+Char:C90($charNumber)
//End if 

$0:=$position
