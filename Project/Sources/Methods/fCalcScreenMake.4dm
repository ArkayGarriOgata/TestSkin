//%attributes = {"publishedWeb":true}
//fCalcScreenMake()   -JML  8/5/93
//581 Screen Making
//11/22/94 add up oop cost

C_LONGINT:C283($1; $waste; $net; $gross; $0; $ColorTotal)
C_REAL:C285($MR_hrs)

$net:=$1  //equals last gross
$Waste:=0  //WASTE
$gross:=$net+$waste
$ColorTotal:=[Estimates_Machines:20]Flex_field1:18  //  `color total=# of screens
//MAKE READY
$MR_hrs:=[Cost_Centers:27]MR_perSomething:34*$ColorTotal
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 
//RUNNING RATE
[Estimates_Machines:20]RunningRate:31:=0
//Store Totals & calc $ costs
[Estimates_Machines:20]Qty_Gross:22:=$gross
[Estimates_Machines:20]Qty_Waste:23:=$waste
[Estimates_Machines:20]Qty_Net:24:=$net
[Estimates_Machines:20]RunningHrs:32:=0
[Estimates_Machines:20]CostLabor:13:=([Estimates_Machines:20]RunningHrs:32+[Estimates_Machines:20]MakeReadyHrs:30)*[Cost_Centers:27]MHRlaborSales:4
[Estimates_Machines:20]CostOverhead:15:=([Estimates_Machines:20]RunningHrs:32+[Estimates_Machines:20]MakeReadyHrs:30)*[Cost_Centers:27]MHRburdenSales:5
[Estimates_Machines:20]CostOOP:28:=Round:C94(([Estimates_Machines:20]CostOverhead:15+[Estimates_Machines:20]CostLabor:13); 0)  //11/22/94
$0:=$gross