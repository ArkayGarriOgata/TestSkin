//%attributes = {}
//$1=Text to strip chars from (Front and back)
//$2=Char to strip
$0:=$1
While (Substring:C12($0; 1; 1)=$2)
	$0:=Substring:C12($0; 2)
End while 


While (Substring:C12($0; Length:C16($0); 1)=$2)
	$0:=Substring:C12($0; 1; Length:C16($0)-1)
End while 
