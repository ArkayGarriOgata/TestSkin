//%attributes = {"publishedWeb":true}
//fCalcLaminator()   -JML  8/4/93
//473 Acetate Laminator

C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs)

$net:=PlannedNet  // to match HP kluge style waste calculation

//WASTE
$Waste:=fCalcStdWaste($Net)

$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	//roll are nominally 16440LF, sheets vary, so someone 
	//says 7500 sheets/roll is close enough  
	$MR_hrs:=Int:C8($gross/7500)*[Cost_Centers:27]MR_perSomething:34  //something per ave roll length
	$MR_hrs:=$MR_hrs+[Cost_Centers:27]MR_forSomething:35  //the is for the first roll
	If ($MR_hrs<[Cost_Centers:27]MR_mimumum:33)
		$MR_hrs:=[Cost_Centers:27]MR_mimumum:33  //alway give at least this much
	End if 
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