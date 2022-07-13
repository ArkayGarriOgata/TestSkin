//%attributes = {"publishedWeb":true}
//fCalcStdTotals()   -JML   8/4/93, mod, mlb 11.11.93
//mod mlb 11/9/93
//used by the fCalc() procedures, calculates totpmachine
//•090399  mlb  UPR 2052 switch to CostCtrCurrent for cost structure

C_LONGINT:C283($Gross; $Waste; $Net; $1; $2; $3; $4)
C_REAL:C285($hrs)

$Gross:=$1
$Waste:=$2
$Net:=$3

[Estimates_Machines:20]Qty_Gross:22:=$gross
[Estimates_Machines:20]Qty_Waste:23:=$waste
[Estimates_Machines:20]Qty_Net:24:=$net
If (Count parameters:C259=4)
	$gross:=$4  //convert to linear feet
End if 

If ([Estimates_Machines:20]RunningRate:31#0)
	// [Machine_Est]RunningHrs:=util_roundUp (($gross/[Machine_Est]RunningRate))
	[Estimates_Machines:20]RunningHrs:32:=Round:C94(($gross/[Estimates_Machines:20]RunningRate:31); 2)
	//[Machine_Est]RunningRate:=[Machine_Est]Qty_Gross/[Machine_Est]RunningHrs
Else 
	[Estimates_Machines:20]RunningHrs:32:=0
End if 

If (bTrates=1)
	If (Position:C15([Estimates_Machines:20]CostCtrID:4; <>GLUERS)=0)  //use gluer overrides or belt speed
		[Estimates_Machines:20]RunningHrs:32:=CostCtr_RunHrsTransient([Estimates_Machines:20]Qty_Gross:22; 25)
		[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Qty_Gross:22/[Estimates_Machines:20]RunningHrs:32
	End if 
End if 

$hrs:=[Estimates_Machines:20]RunningHrs:32+[Estimates_Machines:20]MakeReadyHrs:30
[Estimates_Machines:20]CostLabor:13:=$hrs*CostCtrCurrent("Labor"; [Estimates_Machines:20]CostCtrID:4)
[Estimates_Machines:20]CostOverhead:15:=$hrs*CostCtrCurrent("Burden"; [Estimates_Machines:20]CostCtrID:4)
[Estimates_Machines:20]CostOOP:28:=Round:C94(([Estimates_Machines:20]CostOverhead:15+[Estimates_Machines:20]CostLabor:13); 0)
[Estimates_Machines:20]CostLabor:13:=Round:C94([Estimates_Machines:20]CostLabor:13; 0)
[Estimates_Machines:20]CostOverhead:15:=Round:C94([Estimates_Machines:20]CostOverhead:15; 0)
//
[Estimates_Machines:20]CostScrap:12:=Round:C94(($hrs*CostCtrCurrent("Scrap"; [Estimates_Machines:20]CostCtrID:4)); 2)

If ([Estimates_Machines:20]CalcOvertimeFlg:42)
	[Estimates_Machines:20]CostOvertime:41:=Round:C94(([Estimates_Machines:20]CostLabor:13*0.5); 2)
Else 
	[Estimates_Machines:20]CostOvertime:41:=0
End if 