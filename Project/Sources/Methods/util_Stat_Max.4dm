//%attributes = {"publishedWeb":true}
//PM: util_Stat_Max(exp1;exp2..) -> max expression
//@author mlb - 9/20/02  16:14

//see also util_Stat_Min(exp1;exp2..) 
$params:=Count parameters:C259
If ($params>0)
	ARRAY REAL:C219($argv; $params)
	For ($i; 1; $params)
		$argv{$i}:=${$i}
	End for 
	
	SORT ARRAY:C229($argv; <)
	$0:=$argv{1}
	
Else 
	$0:=0
End if 