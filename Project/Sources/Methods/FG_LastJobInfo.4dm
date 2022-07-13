//%attributes = {"publishedWeb":true}
//PM:  FG_LastJobInfo  110999  mlb
//formerly  `(p) gJobFGLastValue `5/3/95 chip
//5;8;95 adjustinments by mel
//assigns the last values based on the current job

C_TEXT:C284($1; $2; $Cust; $cpn)
C_LONGINT:C283($JobNo; $3)

$Cust:=$1
$cpn:=$2
$JobNo:=$3
$numFG:=qryFinishedGood($Cust; $cpn)

If ($numFG=0)
	CREATE RECORD:C68([Finished_Goods:26])
End if 

FG_Cspec2FG(0)  //5/3/95 upr 1489 chip

If ($JobNo#0)
	[Finished_Goods:26]LastJobNo:16:=String:C10($JobNo)
End if 

If ([Estimates_Carton_Specs:19]CostWant_Per_M:25#0)
	[Finished_Goods:26]LastCost:26:=[Estimates_Carton_Specs:19]CostWant_Per_M:25  //assign cost from carton spec
End if 

SAVE RECORD:C53([Finished_Goods:26])