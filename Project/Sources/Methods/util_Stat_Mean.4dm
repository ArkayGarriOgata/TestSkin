//%attributes = {"publishedWeb":true}
//PM: util_Stat_Mean(->array) -> mean
//@author mlb - 3/18/02  13:54
C_REAL:C285($0; $sum)
C_LONGINT:C283($i; $population)
C_POINTER:C301($1; $series)
$series:=$1
$population:=Size of array:C274($series->)
If ($population>0)
	$sum:=0
	For ($i; 1; $population)
		$sum:=$sum+$series->{$i}
	End for 
	$0:=Round:C94($sum/$population; 4)
	
Else 
	$0:=0
End if 
//