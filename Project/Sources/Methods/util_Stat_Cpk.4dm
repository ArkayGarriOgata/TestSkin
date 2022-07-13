//%attributes = {"publishedWeb":true}
//PM: util_Stat_Cpk(lowerlimit;upperlimit;mean;stdDev) -> r:Cpk
//@author mlb - 9/24/02  15:29
//ref: http://www.pqsystems.com/cpk-with-one-spec.htm
//note: higher is better
C_REAL:C285($0; $1; $2; $3; $4; $lowerStdLimit; $upperStdLimit; $stdDev; $mean; $Zupper; $Zlower; $Zmin; $Cpk)
$lowerStdLimit:=$1
$upperStdLimit:=$2
$mean:=$3
$stdDev:=$4

Case of 
	: ($lowerStdLimit#0) & ($upperStdLimit#0) & ($stdDev>0)
		$Zupper:=($upperStdLimit-$mean)/$stdDev
		$Zlower:=($mean-$lowerStdLimit)/$stdDev
		$Zmin:=util_Stat_Min($Zupper; $Zlower)
		$Cpk:=Round:C94($Zmin/3; 2)
		
	: ($upperStdLimit#0) & ($stdDev>0)  //see reference for validity of ignoring lower limit
		$Zmin:=($upperStdLimit-$mean)/$stdDev
		$Cpk:=Round:C94($Zmin/3; 2)
		
	Else 
		$Cpk:=0  //insuffient data to calculate
End case 

$0:=$Cpk