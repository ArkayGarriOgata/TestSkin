//%attributes = {"publishedWeb":true}
//PM: util_iif(boolean expression;true string;false string) -> 
//@author mlb - 6/18/01  10:25

C_TEXT:C284($0)
C_BOOLEAN:C305($1)
C_TEXT:C284($2; $trueValue; $3; $falseValue)
$trueValue:="True"
$falseValue:="False"
If (Count parameters:C259=3)
	$falseValue:=$3
End if 

If (Count parameters:C259>=2)
	$trueValue:=$2
End if 

If ($1)
	$0:=$trueValue
Else 
	$0:=$falseValue
End if 
//