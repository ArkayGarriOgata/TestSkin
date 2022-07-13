//%attributes = {"publishedWeb":true}
//PM: util_Stat_NORMDIST(X;mean;std;TRUE) -> 
//@author mlb - 9/25/02  10:31
//•••• THIS ISN'T CORRECT!•••••
$X:=$1
$mean:=$2
$stdDev:=$3
$cummulative:=$4
$normDistribution:=0

If ($stdDev>0)
	$exponent:=((-1/2)*($X-$mean)^2)/(2*$stdDev)  //-(($X-$stdDev)/(2*$stdDev))
	$normDistribution:=(1/((Square root:C539(2*Pi:K30:1)*$stdDev)))*(Exp:C21($exponent))
End if 

$0:=$normDistribution