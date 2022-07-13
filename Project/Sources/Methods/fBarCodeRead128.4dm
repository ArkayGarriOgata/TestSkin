//%attributes = {"publishedWeb":true}
//PM:  fBarCodeRead128can) ->humanReadable 11/08/00  mlb
//translate a 128 scan back to Human Readable

$scannedCode:=$1

If (Length:C16($scannedCode)%2#0)  //make sure its even
	$scannedCode:="0"+$scannedCode
End if 

$humanReadable:=""
For ($i; 1; Length:C16($scannedCode)-2; 2)  //don't include the Mod103 char
	$value:=Num:C11(Substring:C12($scannedCode; $i; 2))+32
	$humanReadable:=$humanReadable+Char:C90($value)
End for 

$0:=$humanReadable