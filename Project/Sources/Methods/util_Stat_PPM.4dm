//%attributes = {"publishedWeb":true}
//PM: util_Stat_PPM(lowerlimit;upperlimit;mean;stdDev) -> 
//@author mlb - 9/24/02  16:08
//ref: http://www.davidmlane.com/hyperstat/normal_distribution.html

C_REAL:C285($0; $1; $2; $3; $4; $lowerlimit; $upperlimit; $stdDev; $mean; $upperVar; $lowerVar)
$lowerlimit:=$1
$upperlimit:=$2
$mean:=$3
$stdDev:=$4

If ($stdDev>0)
	$lowerVar:=0
	If ($lowerlimit#0)
		$lowerVar:=util_Stat_NORMDIST($lowerlimit; $mean; $stdDev; True:C214)
	End if 
	
	$upperVar:=0
	If ($upperlimit#0)
		$upperVar:=1-util_Stat_NORMDIST($upperlimit; $mean; $stdDev; True:C214)
	End if 
	
	$0:=Round:C94(($lowerVar+$upperVar); 4)  //*1000000
	
Else 
	$0:=0
End if 