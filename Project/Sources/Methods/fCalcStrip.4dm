//%attributes = {"publishedWeb":true}
//fCalcStrip()   -JML  8/4/93
//490 Stripping 
//modified 1/18/94 by mlb under UPR#1006, 3/23/94 upr1043

C_LONGINT:C283($1; $waste; $net; $gross; $0; $NumberUp; $3)
C_REAL:C285($MR_hrs; $2; $Caliper; $break1; $break2; $break3; $break4; $break5; $break6)

$break1:=Round:C94(0.02; 4)  //constants don't appear to work in case statements with <=
$break2:=Round:C94(0.022; 4)
$break3:=Round:C94(0.024; 4)
$break4:=Round:C94(0.026; 4)
$break5:=Round:C94(0.028; 4)
$break6:=Round:C94(0.03; 4)
$NumberUp:=$3
$Caliper:=$2
//$net:=$1  ` equals last gross
$net:=PlannedNet  // to match HP kluge style waste calculation
//WASTE
$Waste:=fCalcStdWaste($Net)

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
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	// [Machine_Est]RunningRate:=fCalcDoRunRate ($Gross)    
	Case of 
		: (($Caliper>0) & ($Caliper<=$break1))
			Case of 
				: ($NumberUp<=12)
					[Estimates_Machines:20]RunningRate:31:=3000
				: ($NumberUp<=16)
					[Estimates_Machines:20]RunningRate:31:=2500
				: ($NumberUp<=24)
					[Estimates_Machines:20]RunningRate:31:=2000
				Else 
					[Estimates_Machines:20]RunningRate:31:=1500
			End case 
			
		: (($Caliper>$break1) & ($Caliper<=$break2))
			Case of 
				: ($NumberUp<=12)
					[Estimates_Machines:20]RunningRate:31:=2200
				: ($NumberUp<=16)
					[Estimates_Machines:20]RunningRate:31:=2000
				: ($NumberUp<=24)
					[Estimates_Machines:20]RunningRate:31:=1500
				Else 
					[Estimates_Machines:20]RunningRate:31:=1200
			End case 
			
		: (($Caliper>$break2) & ($Caliper<=$break3))
			Case of 
				: ($NumberUp<=12)
					[Estimates_Machines:20]RunningRate:31:=1900
				: ($NumberUp<=16)
					[Estimates_Machines:20]RunningRate:31:=1500
				: ($NumberUp<=24)
					[Estimates_Machines:20]RunningRate:31:=1200
				Else 
					[Estimates_Machines:20]RunningRate:31:=1000
			End case 
			
		: (($Caliper>$break3) & ($Caliper<=$break4))
			Case of 
				: ($NumberUp<=12)
					[Estimates_Machines:20]RunningRate:31:=1600
				: ($NumberUp<=16)
					[Estimates_Machines:20]RunningRate:31:=1200
				: ($NumberUp<=24)
					[Estimates_Machines:20]RunningRate:31:=1000
				Else 
					[Estimates_Machines:20]RunningRate:31:=800
			End case 
			
		: (($Caliper>$break4) & ($Caliper<=$break5))
			Case of 
				: ($NumberUp<=12)
					[Estimates_Machines:20]RunningRate:31:=1400
				: ($NumberUp<=16)
					[Estimates_Machines:20]RunningRate:31:=1000
				: ($NumberUp<=24)
					[Estimates_Machines:20]RunningRate:31:=800
				Else 
					[Estimates_Machines:20]RunningRate:31:=600
			End case 
			
		: (($Caliper>$break5) & ($Caliper<=$break6))
			Case of 
				: ($NumberUp<=12)
					[Estimates_Machines:20]RunningRate:31:=1400  //HP USES 0
				: ($NumberUp<=16)
					[Estimates_Machines:20]RunningRate:31:=1000  //HP USES 0
				: ($NumberUp<=24)
					[Estimates_Machines:20]RunningRate:31:=800  //HP USES 0
				Else 
					[Estimates_Machines:20]RunningRate:31:=600  //HP USES 0
			End case 
			
		Else 
			vFailed:=True:C214
			ALERT:C41("490:  The caliper values must be > 0.000 and ≤ "+String:C10($break6; "0.000#")+Char:C90(13)+"otherwise use override run rate.")
			[Estimates_Machines:20]RunningRate:31:=0
	End case 
End if 

fCalcStdTotals($Gross; $Waste; $net)
$0:=$gross