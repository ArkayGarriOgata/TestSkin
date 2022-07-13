//%attributes = {"publishedWeb":true}
//PM: util_NPV(rate;->arrayOfRevenueStream) -> 
//@author mlb - 4/23/01  13:58

//sum of, from j=1 to n : value of j / (1+rate)^j
$revStream:=$2
$rate:=1+$1

$npv:=0

For ($j; 1; Size of array:C274($revStream->))
	If (($rate^$j)#0)
		$npv:=$npv+($revStream->{$j}/($rate^$j))
	End if 
	IDLE:C311
End for 

$0:=Round:C94($npv; 2)
//