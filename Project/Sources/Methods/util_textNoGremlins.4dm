//%attributes = {"publishedWeb":true}
//util_textNoGremlins(->text)
//see also txt_Gremlinizer

C_POINTER:C301($1; $textPtr)
C_LONGINT:C283($len; $i; $chr)

$textPtr:=$1
$len:=Length:C16($textPtr->)

For ($i; 1; $len)
	$chr:=Character code:C91($textPtr->[[$i]])
	If ($chr<10) | ($chr>255)
		$textPtr->[[$i]]:="??"
		BEEP:C151
	End if 
End for 