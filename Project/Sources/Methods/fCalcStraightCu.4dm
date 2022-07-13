//%attributes = {"publishedWeb":true}
//fCalcStraightCu()   -JML  8/4/93, mod mlb 11.11.93
//496 Straight Cutter

C_LONGINT:C283($1; $waste; $net; $gross; $0; $CutTotal)
C_REAL:C285($MR_hrs)
C_REAL:C285($Caliper; $Rate; $2)

$Caliper:=$2
//$net:=$1  ` equals last gross
$net:=PlannedNet  // to match HP kluge style waste calculation

//WASTE
$waste:=fCalcStdWaste($Net)
$cutTotal:=[Estimates_Machines:20]Flex_field1:18
If ($CutTotal=0)
	//vFailed:=True
	$CutTotal:=1
	ALERT:C41("Number of cuts the Straight Cutter will make unknown, using 1.")
End if 
$net:=$1  // to recover from HP kluge style waste calculation  
$gross:=$net+$waste

//MAKE READY
$MR_hrs:=0
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE
// $MTotal:=$Gross/1000

If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	Case of 
		: (($Caliper>=0.016) & ($Caliper<=0.02))
			$rate:=1000/(0.5*$CutTotal)
		: (($Caliper>0.02) & ($Caliper<=0.024))
			$rate:=1000/(1*$CutTotal)
		: (($Caliper>0.024) & ($Caliper<=0.03))
			$rate:=1000/(1.5*$CutTotal)
		Else 
			$rate:=1000/(0.25*$CutTotal)
	End case 
	[Estimates_Machines:20]RunningRate:31:=$Rate
	
End if 

fCalcStdTotals($Gross; $Waste; $net)

$0:=$gross