//%attributes = {"publishedWeb":true}
//fCalcHandFeed()   -JML  8/4/93
//584 Thompson Hand Feed

C_LONGINT:C283($EmbossUnits; $FlatUnits; $ComboUnits)
C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs)

$EmbossUnits:=1
$FlatUnits:=0
$ComboUnits:=0
$net:=PlannedNet  // to match HP kluge style waste calculation
$Waste:=fCalcStdWaste($Net)
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

fCalcEFCUnits
$MR_hrs:=0
$MR_hrs:=$MR_hrs+(vUnitsEmbos*[Cost_Centers:27]MR_perSomething:34)
$MR_hrs:=$MR_hrs+((vUnitsCombo+vUnitsFlat)*[Cost_Centers:27]MR_addition:36)
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