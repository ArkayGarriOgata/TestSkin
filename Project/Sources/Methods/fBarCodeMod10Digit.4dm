//%attributes = {"publishedWeb":true}
//PM:  fBarCodeMod10Digitext)->character  10/26/00  mlb
//  `return the Modulo 10 check character of a string
//mlb 10/18/01 deal with 0 remainder

C_TEXT:C284($1)  //date to encode
C_TEXT:C284($0)
C_LONGINT:C283($expectedLength)

$expectedLength:=Length:C16($1)  //19
// test 01234567890 should be 5 ber Appx B,"A Guide to Bar Coding"
//$expectedLength:=11
If (Length:C16($1)=$expectedLength)  // | (Count parameters=2)
	C_LONGINT:C283($position; $value; $chkDigitValue; $odd; $even)
	//If (True) 
	//P&G method,sum the odd, multiply by 3, sum the even, add then mod 10    
	$odd:=0
	For ($position; 1; $expectedLength; 2)
		$odd:=$odd+Num:C11($1[[$position]])
	End for 
	$odd:=$odd*3
	
	$even:=0
	For ($position; 2; $expectedLength; 2)
		$even:=$even+Num:C11($1[[$position]])
	End for 
	
	$value:=$odd+$even
	$remainder:=$value%10
	If ($remainder#0)  //mlb 10/18/01
		$chkDigitValue:=10-($value%10)
	Else 
		$chkDigitValue:=0
	End if 
	$0:=String:C10($chkDigitValue)
	
	// Else 
	//C_LONGINT($weightedTotal;$char;$weightedTotal)
	//$weightedTotal:=0
	//For ($position;1;Length($1))
	//$char:=Ascii($1≤$position≥)
	//If ($char<135)
	//$value:=$char-32
	//Else 
	//$value:=$char-100
	//End if 
	//$value:=$value*$position
	//$weightedTotal:=$weightedTotal+$value
	//End for 
	//
	//$chkDigitValue:=($weightedTotal%10)+48
	//$0:=Char($chkDigitValue)
	//End if 
	
Else 
	BEEP:C151
	zwStatusMsg("ERROR"; "Mod10 Checkdigit expects 19 characters")
	$0:="E"
End if 