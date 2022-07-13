//%attributes = {"publishedWeb":true}
//fCalcTransit

C_LONGINT:C283($0; $1; $skids)
C_REAL:C285($MR_hrs)

$0:=$1  //equals last gross
$skids:=Int:C8($1/2000)

[Estimates_Machines:20]Comment:29:="Allowance for shipping "+String:C10($skids)+" skids."
[Estimates_Machines:20]MakeReadyHrs:30:=0
[Estimates_Machines:20]RunningRate:31:=0
[Estimates_Machines:20]CostLabor:13:=$skids*CostCtrCurrent("Labor"; [Estimates_Machines:20]CostCtrID:4)
[Estimates_Machines:20]CostOverhead:15:=$skids*CostCtrCurrent("Burden"; [Estimates_Machines:20]CostCtrID:4)
[Estimates_Machines:20]CostOOP:28:=Round:C94(([Estimates_Machines:20]CostOverhead:15+[Estimates_Machines:20]CostLabor:13); 0)
[Estimates_Machines:20]CostLabor:13:=Round:C94([Estimates_Machines:20]CostLabor:13; 0)
[Estimates_Machines:20]CostOverhead:15:=Round:C94([Estimates_Machines:20]CostOverhead:15; 0)
[Estimates_Machines:20]CostScrap:12:=Round:C94(($skids*CostCtrCurrent("Scrap"; [Estimates_Machines:20]CostCtrID:4)); 2)

If ([Estimates_Machines:20]CalcOvertimeFlg:42)
	[Estimates_Machines:20]CostOvertime:41:=Round:C94(([Estimates_Machines:20]CostLabor:13*0.5); 2)
Else 
	[Estimates_Machines:20]CostOvertime:41:=0
End if 