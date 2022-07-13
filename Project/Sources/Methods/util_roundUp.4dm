//%attributes = {"publishedWeb":true}
//util_roundUp(real)
C_REAL:C285($1; $value; $0)
C_LONGINT:C283($whole)

$value:=$1
$whole:=Int:C8($value)
$fraction:=$value-$whole
Case of 
	: ($fraction=0)
		$fraction:=0
	: ($fraction<=0.25)
		$fraction:=0.25
	: ($fraction<=0.5)
		$fraction:=0.5
	: ($fraction<=0.75)
		$fraction:=0.75
	Else 
		$fraction:=1
End case 

$0:=$whole+$fraction