//%attributes = {"publishedWeb":true}
//fCalcPress3 ()     -mlb 11/23/93
//calculations for #419 Heidelberg Proofing Press

C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs)

$net:=PlannedNet  // to match HP kluge style waste calculation
//WASTE
$waste:=fCalcStdWaste($net)
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
$MR_hrs:=[Cost_Centers:27]MR_perSomething:34*[Estimates_Machines:20]Flex_field1:18  //# colors
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE  
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate($gross)
End if 

fCalcStdTotals($gross; $waste; $net)
$0:=$gross