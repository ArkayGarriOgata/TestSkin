//%attributes = {}
// Method: util_isNumeric () -> true if only numbers
// ----------------------------------------------------
// by: mel: 01/20/05, 10:42:10
// ----------------------------------------------------
// Description:
// test for all numeric strings
// considered (Substring($DataToFormat;1;4)=(String(Num(Substring($DataToFormat;1;4)))))
// but -, ., e are problems

// ----------------------------------------------------
C_LONGINT:C283($i)
C_TEXT:C284($1)
If (Length:C16($1)>0)  // Modified by: Mel Bohince (10/9/19) 
	$0:=True:C214  //optomisic
Else   //loop won't test
	$0:=False:C215
End if 

For ($i; 1; Length:C16($1))
	$char:=Character code:C91($1[[$i]])
	If ($char<48) | ($char>57)
		$0:=False:C215
		$i:=1+Length:C16($1)
	End if 
End for 
//
