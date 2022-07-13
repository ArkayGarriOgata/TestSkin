//%attributes = {"publishedWeb":true}
//fCalcHeidleDieC()   -JML  8/4/93
//583 Heidelberg Die Cutter

C_LONGINT:C283($1; $waste; $net; $gross; $0; $NumberUp; $2)
C_REAL:C285($MR_hrs)

$net:=PlannedNet  // to match HP kluge style waste calculation

//WASTE
$Waste:=fCalcStdWaste($Net)
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
//need to count the # of ups and add the PErsomething time for each up.
$NumberUp:=$2

$MR_hrs:=$NumberUp*[Cost_Centers:27]MR_perSomething:34
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate($Gross)
End if 

fCalcStdTotals($Gross; $Waste; $net)
$0:=$gross