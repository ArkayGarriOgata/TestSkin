//%attributes = {"publishedWeb":true}
//fCalcPress()     -JML      8/2/93 mlb 11/9/93 called by sRunEstimate
//                                               1/21/94
//3/23/94 upr 1043
//3/15/95 upr 66
//413, 414, 415 heidelberg presses
//• mlb - 5/15/02  11:36 add for Color Standard
// • mel (6/16/05, 10:35:46) don't add min on 415
// Modified by: Mel Bohince (7/18/16) [Estimates_Machines]Flex_field6 now used for "backside" not spot/solid

C_LONGINT:C283($1; $waste; $net; $gross; $0; $Numberup; $2; $ColorTtl; $PlateTtl)
C_REAL:C285($MR_hrs; $3; $caliper)
C_BOOLEAN:C305($SolidCoatin; $SpotCoating)
$SpotCoating:=False:C215
$SolidCoatin:=False:C215

$net:=PlannedNet  // to match HP kluge style waste calculation
$numberUp:=$2
$caliper:=$3
//SEARCH([Material_Est];[Material_Est]Seq_CC_key=[Machine_Est]Seq_CC_key;*)
//SEARCH([Material_Est]; & [Material_Est]Commodity_Key="2@")  `indicates INK commd
//$ColorTotal:=Records in selection([Material_Est])
//$PlateTtl:=[CaseForm]DieChangeTtl
//$ColorTtl:=[Machine_Est]Flex_Field2
//$PlateTtl:=[Machine_Est]Flex_field1
$ColorTtl:=[Estimates_Machines:20]Flex_field1:18  //3/15/95 upr 66 swap these
$PlateTtl:=[Estimates_Machines:20]Flex_Field2:19

//WASTE 
$waste:=0  //[COST_CENTER]WA_Startup

Case of 
	: ($net<=[Cost_Centers:27]WA_running1to:19)
		$waste:=$waste+($net*([Cost_Centers:27]WA_running1:20/100))
		If ($NumberUp<5)
			$waste:=$waste+($net*([Cost_Centers:27]Field56:56/100))
		End if 
		If ($waste<[Cost_Centers:27]WA_min:18)
			$waste:=[Cost_Centers:27]WA_min:18
		End if 
		
	: ($net<=[Cost_Centers:27]WA_running2to:21)
		$waste:=$waste+($net*([Cost_Centers:27]WA_running2:22/100))
		If ($waste<[Cost_Centers:27]Field57:57)
			$waste:=[Cost_Centers:27]Field57:57
		End if 
		
	: ($net<=[Cost_Centers:27]WA_running3to:23)
		$waste:=$waste+($net*([Cost_Centers:27]WA_running3:24/100))
		If ($waste<[Cost_Centers:27]Field58:58)
			$waste:=[Cost_Centers:27]Field58:58
		End if 
End case 
// If ($waste<[COST_CENTER]WA_min)
// $waste:=[COST_CENTER]WA_min
// End if 
$Waste:=$waste+($ColorTtl*[Cost_Centers:27]WA_Startup:30)+($PlateTtl*[Cost_Centers:27]WA_perSomething:31)

If ([Estimates_Machines:20]WasteAdj_Percen:40>0)
	$waste:=([Estimates_Machines:20]WasteAdj_Percen:40/100)*$Waste
End if 
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	$MR_hrs:=($ColorTtl*[Cost_Centers:27]MR_perSomething:34)+($PlateTtl*[Cost_Centers:27]MR_reduction:37)
	
	If ([Estimates_Machines:20]Flex_Field5:25)
		$SpotCoating:=True:C214
	Else 
		$SolidCoatin:=True:C214
	End if 
	
	If ($SpotCoating)
		$MR_hrs:=$MR_Hrs+[Cost_Centers:27]MR_addition:36  //add Spot Coated or Solid Coater charge
	End if 
	If ($SolidCoatin)
		$MR_hrs:=$MR_Hrs+[Cost_Centers:27]MR_forSomething:35
	End if 
	
	//If ([COST_CENTER]ID="415")  `                                  change in 1/1/94 stds
	//$MR_hrs:=$MR_Hrs+[COST_CENTER]MR_mimumum
	//End if 
	
	If ($MR_hrs<[Cost_Centers:27]MR_mimumum:33)
		$MR_hrs:=[Cost_Centers:27]MR_mimumum:33
	End if 
	
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE   
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate($Gross; $SpotCoating; ($caliper>Round:C94(0.022; 4)))
	//If ($SpotCoating)
	//[Machine_Est]RunningRate:=[Machine_Est]RunningRate*(1-([COST_CENTER]RS
	//«_reduction1/100))
	//End if 
	//If ($caliper>Round(0.022;4))
	//[Machine_Est]RunningRate:=[Machine_Est]RunningRate*(1-([COST_CENTER]RS
	//«_reduction2/100))
	//End if 
End if 

fCalcStdTotals($Gross; $waste; $Net)
If ([Estimates_DifferentialsForms:47]ColorStdSheets:34#0)  //• mlb - 5/15/02  11:36 add for Color Standard
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MakeReadyHrs:30+1
	[Estimates_Machines:20]RunningHrs:32:=Round:C94((($gross+[Estimates_DifferentialsForms:47]ColorStdSheets:34)/[Estimates_Machines:20]RunningRate:31); 2)
	$hrs:=[Estimates_Machines:20]RunningHrs:32+[Estimates_Machines:20]MakeReadyHrs:30
	[Estimates_Machines:20]CostLabor:13:=$hrs*CostCtrCurrent("Labor"; [Estimates_Machines:20]CostCtrID:4)
	[Estimates_Machines:20]CostOverhead:15:=$hrs*CostCtrCurrent("Burden"; [Estimates_Machines:20]CostCtrID:4)
	[Estimates_Machines:20]CostOOP:28:=Round:C94(([Estimates_Machines:20]CostOverhead:15+[Estimates_Machines:20]CostLabor:13); 0)
	[Estimates_Machines:20]CostLabor:13:=Round:C94([Estimates_Machines:20]CostLabor:13; 0)
	[Estimates_Machines:20]CostOverhead:15:=Round:C94([Estimates_Machines:20]CostOverhead:15; 0)
	[Estimates_Machines:20]CostScrap:12:=Round:C94(($hrs*CostCtrCurrent("Scrap"; [Estimates_Machines:20]CostCtrID:4)); 2)
	If ([Estimates_Machines:20]CalcOvertimeFlg:42)
		[Estimates_Machines:20]CostOvertime:41:=Round:C94(([Estimates_Machines:20]CostLabor:13*0.5); 2)
	Else 
		[Estimates_Machines:20]CostOvertime:41:=0
	End if 
End if 

$0:=$gross  //return last gross