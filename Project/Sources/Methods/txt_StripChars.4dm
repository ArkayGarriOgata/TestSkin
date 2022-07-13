//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 08/21/17, 14:58:21
// ----------------------------------------------------
// Method: StripChars
// Description
// 
//
// Parameters
// ----------------------------------------------------

//$1=Text to strip from
//$2=Character to strip
$0:=$1
$xlLen:=Length:C16($2)
While (Substring:C12($0; 1; $xlLen)=$2)
	$0:=Substring:C12($0; $xlLen+1)
End while 

While (Substring:C12($0; Length:C16($0)-($xlLen-1))=$2)
	$0:=Substring:C12($0; 1; Length:C16($0)-$xlLen)
End while 
