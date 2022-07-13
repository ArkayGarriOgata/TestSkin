//%attributes = {"publishedWeb":true}
//fCalcGluer().    481 Gluer mod mlb 2/10/94, 3/28/94
//mod 5/24/94 upr 1112
// • mel (6/9/05, 09:23:42) use BenMarkens rate/inch formula in test mode

C_LONGINT:C283($waste; $net; $gross; $numMRs; $0; $1; $2; $yield; $yldWaste)
C_REAL:C285($MR_hrs)
C_BOOLEAN:C305($Imaje; $strateLine)  //;$4;$3)
C_POINTER:C301($3)  //return the yld waste

$Imaje:=[Estimates_Machines:20]Flex_field6:37
$strateLine:=Not:C34([Estimates_Machines:20]Flex_Field5:25)
$net:=[Estimates_Machines:20]Flex_field1:18

If ($net=0)
	$net:=$1  //= want qty of cartons at carton spec level
End if 

$numMRs:=[Estimates_Machines:20]Flex_Field2:19
If ($numMRs=0)
	$numMRs:=1
End if 

$yield:=[Estimates_Machines:20]Flex_Field3:20
If ($yield=0)
	$yield:=$2  //= want qty of cartons at carton spec level
End if 

//WASTE
$Waste:=fCalcStdWaste($net)

If ($numMRs>1)  //upr 1112
	$temp:=(($numMRs-1)*[Cost_Centers:27]WA_Startup:30)
	If ([Estimates_Machines:20]WasteAdj_Percen:40>0)
		$temp:=([Estimates_Machines:20]WasteAdj_Percen:40/100)*$temp
	End if 
	$Waste:=$Waste+$temp
End if 

If (Not:C34($strateLine))
	$waste:=$waste+(([Cost_Centers:27]WA_perSomething:31/100)*$net)
End if 

$gross:=$net+$waste

//MAKE READY
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	$MR_hrs:=0
	If (($strateLine) & (Not:C34($Imaje)))
		$MR_hrs:=$MR_hrs+([Cost_Centers:27]MR_mimumum:33*$numMRs)
	Else 
		$MR_hrs:=$MR_hrs+([Cost_Centers:27]MR_forSomething:35*$numMRs)
	End if 
	
	If ($Imaje)
		$MR_hrs:=$MR_hrs+([Cost_Centers:27]MR_addition:36*($net/[Cost_Centers:27]MR_reduction:37))
	End if 
	
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE 
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	If ($Imaje)
		[Estimates_Machines:20]RunningRate:31:=[Cost_Centers:27]RS_Spl:52
	Else 
		[Estimates_Machines:20]RunningRate:31:=[Cost_Centers:27]RS_Medium:48
	End if 
End if 

fCalcStdTotals($Gross; $Waste; $Net)

$runHrs:=0
For ($item; 1; Size of array:C274(aCartonProportion))
	$cartons:=aCartonProportion{$item}*$Gross
	If (aCartonsPerHr{$item}>0)
		$runHrs:=$runHrs+($cartons/aCartonsPerHr{$item})
	End if 
End for 

If ($runHrs>0)
	$calcRunRate:=Trunc:C95($Gross/$runHrs; -2)
	$p1:=Position:C15("<rate>"; [Estimates_Machines:20]Comment:29)
	$p2:=Position:C15("</rate>"; [Estimates_Machines:20]Comment:29)
	If ($p1>0) & ($p2>0)
		[Estimates_Machines:20]Comment:29:=Delete string:C232([Estimates_Machines:20]Comment:29; $p1; (($p2+7)-$p1+1))
	End if 
	[Estimates_Machines:20]Comment:29:="<rate>calc'd belt rate "+String:C10($calcRunRate)+" units/hr </rate> "+[Estimates_Machines:20]Comment:29
End if 

If (bTestRates=1) & ([Estimates_Machines:20]Run_Override:27=0)  //respect overides
	[Estimates_Machines:20]RunningHrs:32:=Round:C94($runHrs; 2)
	[Estimates_Machines:20]RunningRate:31:=Trunc:C95($Gross/[Estimates_Machines:20]RunningHrs:32; -2)
	$hrs:=[Estimates_Machines:20]RunningHrs:32+[Estimates_Machines:20]MakeReadyHrs:30
	[Estimates_Machines:20]CostLabor:13:=$hrs*CostCtrCurrent("Labor"; [Estimates_Machines:20]CostCtrID:4)
	[Estimates_Machines:20]CostOverhead:15:=$hrs*CostCtrCurrent("Burden"; [Estimates_Machines:20]CostCtrID:4)
	[Estimates_Machines:20]CostOOP:28:=Round:C94(([Estimates_Machines:20]CostOverhead:15+[Estimates_Machines:20]CostLabor:13); 0)
	[Estimates_Machines:20]CostLabor:13:=Round:C94([Estimates_Machines:20]CostLabor:13; 0)
	[Estimates_Machines:20]CostOverhead:15:=Round:C94([Estimates_Machines:20]CostOverhead:15; 0)
	[Estimates_Machines:20]CostScrap:12:=Round:C94(($hrs*CostCtrCurrent("Scrap"; [Estimates_Machines:20]CostCtrID:4)); 2)
End if 

If ($yield#$net)
	$yldWaste:=fCalcStdWaste($yield)
	If (Not:C34($strateLine))
		$yldWaste:=$yldWaste+(([Cost_Centers:27]WA_perSomething:31/100)*$yield)
	End if 
	$yldWaste:=$yldWaste-$waste  //just the difference in waste  
	$yield:=$yield+$yldWaste
	
	fCalcYield($yield-$net)
Else 
	$yldWaste:=0
End if 

//$0:=$gross
$3->:=$yldWaste
$0:=$waste  //$gross  