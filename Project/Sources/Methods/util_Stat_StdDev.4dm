//%attributes = {"publishedWeb":true}
//PM: util_Stat_StdDev(->array) -> std dev
//@author mlb - 3/18/02  13:54

C_REAL:C285($0; $sum; $mean; $variance)
C_LONGINT:C283($i; $population)
C_POINTER:C301($1; $series)
$series:=$1
$population:=Size of array:C274($series->)
If ($population>1)
	$sum:=0
	For ($i; 1; $population)
		$sum:=$sum+$series->{$i}
	End for 
	$mean:=$sum/$population
	
	$variance:=0
	For ($i; 1; $population)
		$variance:=$variance+(($series->{$i}-$mean)^2)
	End for 
	
	$0:=Round:C94(Square root:C539($variance/($population-1)); 4)
	
Else 
	$0:=0
End if 
//