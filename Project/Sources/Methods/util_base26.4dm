//%attributes = {"publishedWeb":true}
//PM:  uil_base26(number)->letters  4/11/01  mlb
//convert a number into a 2 digit base 27
C_LONGINT:C283($base10; $1; $maximum; $offset; $newBase; $big; $little)
$base10:=$1
$newBase:=26
$maximum:=($newBase*$newBase)-1
$offset:=Character code:C91("A")
C_TEXT:C284($littleDigit; $bigDigit)
C_TEXT:C284($0)

Case of 
	: ($base10<=$maximum)
		$big:=$base10\$newBase
		$little:=$base10-($newBase*$big)
		$bigDigit:=Char:C90($big+$offset)  //A=65
		$littleDigit:=Char:C90($little+$offset)
		
	Else 
		$bigDigit:="<"
		$littleDigit:="<"
End case 

$0:=$bigDigit+$littleDigit
//