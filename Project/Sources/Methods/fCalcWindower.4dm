//%attributes = {"publishedWeb":true}
//fCalcWindower().    486 Windower mod 2.10.94,3/28/94
//upr 1277 11/3/94

C_LONGINT:C283($waste; $net; $gross; $0; $1; $2; $3; $yield; $temp; $yldWaste; $5; $prevYDWast; $prevGross)
C_REAL:C285($MR_hrs)
C_POINTER:C301($4)

$prevYDWast:=$5
$prevGross:=$2
//$net:=$1
$net:=[Estimates_Machines:20]Flex_Field3:20
If ($net=0)
	$net:=$prevGross  //$1
End if 

$yield:=[Estimates_Machines:20]Flex_Field4:21
If ($yield=0)
	$yield:=$3  //= want qty of cartons at carton spec level
End if 

//WASTE
$Waste:=fCalcStdWaste($net)
$temp:=$net
//$net:=$prevGross  `$2 will include accumlated waste  upr 1277 11/3/94
$gross:=$net+$waste  //$2 will include accumlated waste

//MAKE READY
$MR_hrs:=0
$lanes:=[Estimates_Machines:20]Flex_field1:18
$UpPerLane:=[Estimates_Machines:20]Flex_Field2:19
Case of 
	: (($lanes=1) & ($UpPerLane=1))
		$MR_hrs:=[Cost_Centers:27]MR_perSomething:34
		[Estimates_Machines:20]RunningRate:31:=[Cost_Centers:27]RS_short:46/2
	: (($lanes=1) & ($UpPerLane=2))
		$MR_hrs:=[Cost_Centers:27]MR_perSomething:34*2
		[Estimates_Machines:20]RunningRate:31:=[Cost_Centers:27]RS_short:46
	: (($lanes=2) & ($UpPerLane=1))
		$MR_hrs:=[Cost_Centers:27]MR_forSomething:35
		[Estimates_Machines:20]RunningRate:31:=[Cost_Centers:27]RS_Medium:48/2
	: (($lanes=2) & ($UpPerLane=2))
		$MR_hrs:=[Cost_Centers:27]MR_forSomething:35*2
		[Estimates_Machines:20]RunningRate:31:=[Cost_Centers:27]RS_Medium:48
	Else 
		BEEP:C151
		ALERT:C41("Windower expects 1 or 2 lanes, and 1 or 2 up per lane.")
End case 

If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
End if 

fCalcStdTotals($Gross; $Waste; $Net)

//$net:=$temp  `back to net cartons    upr 1277 11/3/94
If ($yield#$net)
	$yldWaste:=fCalcStdWaste($yield)
	//$yldWaste:=$yldWaste-$waste  `just the difference in waste  
	
	// fCalcYield (($yield+$yldWaste+$prevYDWast)-$prevGross)
	//fCalcYield (($yield+$yldWaste+$prevYDWast+($prevGross-$net))-$gross)
	//              120k      3.7k              .375k             107.7k      105k   
	fCalcYield($yield-$net)
	$yldWaste:=$yldWaste-$waste  //since it was comment out above
	If ($yldWaste<0)
		$yldWaste:=0
	End if 
Else 
	$yldWaste:=0
End if 

$4->:=$yldWaste
$0:=$waste  //$gross
//return last *****waste**** carton total