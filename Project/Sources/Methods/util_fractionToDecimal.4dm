//%attributes = {}
// Method: util_fractionToDecimal ("9-1/4") -> "9.25"
// ----------------------------------------------------
// by: mel: 05/20/05, 21:05:10
// ----------------------------------------------------
// Description:
// convert a fractionized number to decimal
// Updates:

// ----------------------------------------------------
C_LONGINT:C283($slash; $numerator; $denominator; $whole)
C_TEXT:C284($1; $0; $fraction)
$0:=$1
$slash:=Position:C15("/"; $1)
If ($slash>0)  //else dont change
	$fraction:=Replace string:C233($1; " "; "~")
	$fraction:=Replace string:C233($fraction; "-"; "~")
	
	$denominator:=Num:C11(Substring:C12($fraction; $slash+1))
	If ($denominator#0)  //else don't divide by zero
		$fraction:=Substring:C12($fraction; 1; $slash-1)  //chop the /demom
		$slash:=Position:C15("~"; $fraction)
		If ($slash>0)
			$whole:=Num:C11(Substring:C12($fraction; 1; $slash-1))
		Else 
			$whole:=0
		End if 
		$numerator:=Num:C11(Substring:C12($fraction; $slash+1))
		$0:=Substring:C12(String:C10($whole+Round:C94(($numerator/$denominator); 4)); 1; 20)
	End if 
End if 


