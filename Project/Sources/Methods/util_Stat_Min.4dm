//%attributes = {"publishedWeb":true}
//PM: util_Stat_Min(exp1;exp2) -> lower of two expressions
//@author mlb - 9/20/02  16:07
$params:=Count parameters:C259
If ($params>0)
	ARRAY REAL:C219($argv; $params)
	For ($i; 1; $params)
		$argv{$i}:=${$i}
	End for 
	
	SORT ARRAY:C229($argv; >)
	$0:=$argv{1}
	
Else 
	$0:=0
End if 