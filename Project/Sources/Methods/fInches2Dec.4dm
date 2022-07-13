//%attributes = {"publishedWeb":true}
C_TEXT:C284($1)
C_REAL:C285($0)
C_LONGINT:C283($whole; $numerator; $denominator; $hyph; $slash; $space)

$hyph:=Position:C15("-"; $1)
$slash:=Position:C15("/"; $1)
$space:=Position:C15(" "; $1)

Case of 
	: ($space#0)
		BEEP:C151
		ALERT:C41("Format like: 22  or  22-11/16  or  11/16 (with no spaces)")
		$0:=0
	: (($hyph=0) & ($slash=0))  //no fraction
		$0:=Num:C11($1)
	: (($hyph=0) & ($slash#0))  //no whole
		$numerator:=Num:C11(Substring:C12($1; 1; $slash-1))
		$denominator:=Num:C11(Substring:C12($1; $slash+1; Length:C16($1)))
		$0:=$numerator/$denominator
	: (($hyph#0) & ($slash#0))  //all
		$whole:=Num:C11(Substring:C12($1; 1; $hyph-1))
		$numerator:=Num:C11(Substring:C12($1; $hyph+1; $slash-$hyph-1))
		$denominator:=Num:C11(Substring:C12($1; $slash+1; Length:C16($1)))
		$0:=$whole+($numerator/$denominator)
	Else 
		BEEP:C151
		ALERT:C41("Format like: 22  or  22-11/16  or  11/16 (with no spaces)")
		$0:=0
End case 