//%attributes = {"publishedWeb":true}
//fCalcInkMake()   -JML  8/5/93, mlb 11.23.93
//431 Inkmaking

C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs)

$net:=PlannedNet  // to match HP kluge style waste calculation
//WASTE
$Waste:=fCalcStdWaste($Net)
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY

If ([Estimates_Machines:20]Flex_Field5:25)
	$MR_hrs:=$MR_Hrs+[Cost_Centers:27]MR_reduction:37  //add for color match at gto
End if 

Case of 
	: ([Estimates_Machines:20]Flex_field1:18<=10)  //lbs
		$MR_hrs:=$MR_Hrs+[Cost_Centers:27]MR_perSomething:34
	: ([Estimates_Machines:20]Flex_field1:18<=150)  //lbs
		$MR_hrs:=$MR_Hrs+[Cost_Centers:27]MR_forSomething:35
	Else 
		$MR_hrs:=$MR_Hrs+[Cost_Centers:27]MR_addition:36
End case 

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
	[Estimates_Machines:20]RunningRate:31:=0  // no run rate fCalcDoRunRate ($Gross)
End if 

fCalcStdTotals($Gross; $Waste; $net)
$0:=$gross