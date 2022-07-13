//%attributes = {"publishedWeb":true}
//fCalcStamping3()   -JML  8/3/93 mod, mlb 11.11.93, 2.10.94
//585 Individual Stamping
//upr 164 1/6/94

C_LONGINT:C283($waste; $net; $gross; $0; $NumberUp; $1; $2; $yield; $yldWaste; $4)
C_REAL:C285($MR_hrs)
C_POINTER:C301($3)

//$net:=$1  `equals last gross
$net:=[Estimates_Machines:20]Flex_Field2:19
If ($net=0)
	$net:=$1
End if 

$yield:=[Estimates_Machines:20]Flex_Field3:20
If ($yield=0)
	$yield:=$2  //= want qty of cartons at carton spec level
End if 

//WASTE
$Waste:=fCalcStdWaste($net)

$gross:=$net+$waste

$NumberUp:=[Estimates_Machines:20]Flex_field1:18  //fCalcNumberUp 
If ($NumberUp>2)
	$NumberUp:=2
	BEEP:C151
	ALERT:C41("Number ups for the 585 are 1 or 2, 2 is being used.")
End if 
//$CartonTotal:=$NumberUp*$gross

//MAKE READY
$MR_hrs:=$NumberUp*[Cost_Centers:27]MR_perSomething:34
If ($MR_hrs<[Cost_Centers:27]MR_mimumum:33)
	$MR_hrs:=[Cost_Centers:27]MR_mimumum:33
End if 
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate($NumberUp)  //based on # of up
End if 

fCalcStdTotals($Gross; $Waste; $net)

If ($yield#$net)
	$yldWaste:=fCalcStdWaste($yield)
	$yldWaste:=$yldWaste-$waste  //just the difference in waste  
	
	//fCalcYield ($yield+$yldWaste-$prevGross)
	fCalcYield($yield-$net)  //upr 164 1/6/94
Else 
	$yldWaste:=0
End if 

$3->:=$yldWaste
$0:=$waste  //$gross