//%attributes = {"publishedWeb":true}
//fCalcRoland700($lastGross;$numberUp;$caliper)  051096 mlb
//based on fCalcPress()     called by sRunEstimate, beforeMachineE
//10/17/01 make this subform aware
//• mlb - 5/15/02  11:36 add for Color Standard
// Modified by: Mel Bohince (7/18/16) [Estimates_Machines]Flex_field6 now used for "backside" not easy/difficult

C_LONGINT:C283($1; $waste; $net; $gross; $0; $Numberup; $2; $PrintColors; $PrintPlates; $CoatFlexCol; $CoatFlexPlt; $onPlastic; $3)
C_REAL:C285($MR_hrs; $metallic)
C_BOOLEAN:C305($easyRun; $diffRun; $normRun)
$easyRun:=True:C214
$diffRun:=False:C215

$net:=PlannedNet  // to match HP kluge style waste calculation
$numberUp:=$2
$onPlastic:=$3
$PrintColors:=[Estimates_Machines:20]Flex_field1:18  //5/10/95
$PrintPlates:=[Estimates_Machines:20]Flex_Field2:19
$CoatFlexCol:=[Estimates_Machines:20]Flex_Field3:20
$CoatFlexPlt:=[Estimates_Machines:20]Flex_Field4:21
$normRun:=True:C214  //default
//$easyRun:=[Estimates_Machines]Flex_Field5
$diffRun:=[Estimates_Machines:20]Flex_Field5:25
$metallic:=[Estimates_Machines:20]Flex_Field7:38  //mlb051298

//WASTE 
$waste:=0  //[COST_CENTER]WA_Startup

If ([Estimates_Machines:20]FormChangeHere:9)  //10/17/01 make this subform aware
	$holdNet:=$net
	$net:=Round:C94($net/[Estimates_DifferentialsForms:47]Subforms:31; 0)
End if 

Case of   //*find the Waste percent based on the number of sheets
	: ($net<=[Cost_Centers:27]WA_running1to:19)
		If ([Estimates_Machines:20]FormChangeHere:9)  //10/17/01 make this subform aware
			$net:=$holdNet
		End if 
		$waste:=$waste+($net*([Cost_Centers:27]WA_running1:20/100))
		If ($NumberUp<5)
			$waste:=$waste+($net*([Cost_Centers:27]Field56:56/100))
		End if 
		If ($waste<[Cost_Centers:27]WA_min:18)
			$waste:=[Cost_Centers:27]WA_min:18
		End if 
		
	: ($net<=[Cost_Centers:27]WA_running2to:21)
		If ([Estimates_Machines:20]FormChangeHere:9)  //10/17/01 make this subform aware
			$net:=$holdNet
		End if 
		$waste:=$waste+($net*([Cost_Centers:27]WA_running2:22/100))
		If ($waste<[Cost_Centers:27]Field57:57)
			$waste:=[Cost_Centers:27]Field57:57
		End if 
		
	: ($net<=[Cost_Centers:27]WA_running3to:23)
		If ([Estimates_Machines:20]FormChangeHere:9)  //10/17/01 make this subform aware
			$net:=$holdNet
		End if 
		$waste:=$waste+($net*([Cost_Centers:27]WA_running3:24/100))
		If ($waste<[Cost_Centers:27]Field58:58)
			$waste:=[Cost_Centers:27]Field58:58
		End if 
End case 

If ([Estimates_Machines:20]FormChangeHere:9)  //10/17/01 make this subform aware
	$waste:=$waste+([Estimates_DifferentialsForms:47]Subforms:31*[Cost_Centers:27]RS_reduction2:54)
End if 

$waste:=$waste+($PrintColors*[Cost_Centers:27]WA_Startup:30)+($CoatFlexCol*[Cost_Centers:27]WA_perSomething:31)

If ([Estimates_Machines:20]WasteAdj_Percen:40>0)
	$waste:=([Estimates_Machines:20]WasteAdj_Percen:40/100)*$Waste
End if 

$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
$MR_hrs:=0
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
	
Else 
	$MR_hrs:=($PrintColors*[Cost_Centers:27]MR_perSomething:34)
	$MR_hrs:=$MR_hrs+($PrintPlates*[Cost_Centers:27]MR_forSomething:35)
	$MR_hrs:=$MR_hrs+($CoatFlexCol*[Cost_Centers:27]MR_addition:36)
	$MR_hrs:=$MR_hrs+($CoatFlexPlt*[Cost_Centers:27]MR_reduction:37)
	
	If ($MR_hrs<[Cost_Centers:27]MR_mimumum:33)
		$MR_hrs:=[Cost_Centers:27]MR_mimumum:33
	End if 
	
	If ($metallic>0)  //mlb 51298
		$MR_hrs:=$MR_hrs+((PlannedNet/10000)*0.5)
	End if 
	
	If ([Estimates_Machines:20]FormChangeHere:9)  //10/17/01 make this subform aware
		Case of 
			: (True:C214)
				$MR_hrs:=$MR_hrs+[Estimates_DifferentialsForms:47]Subforms:31
				
			: ([Estimates_DifferentialsForms:47]Subforms:31<=2)
				$MR_hrs:=$MR_hrs*1.25
				
			: ([Estimates_DifferentialsForms:47]Subforms:31<=3)
				$MR_hrs:=$MR_hrs*1.5
				
			: ([Estimates_DifferentialsForms:47]Subforms:31<=4)
				$MR_hrs:=$MR_hrs*2.25
				
			Else 
				$MR_hrs:=$MR_hrs*([Estimates_DifferentialsForms:47]Subforms:31-3)
		End case 
	End if 
	
	//[Machine_Est]MakeReadyHrs:=util_roundUp ($MR_hrs)
	[Estimates_Machines:20]MakeReadyHrs:30:=Round:C94($MR_hrs; 2)
End if 

//RUNNING RATE   
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
	
Else 
	Case of 
		: ($onPlastic>0)  //reduction for APET
			If ($diffRun)
				[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate(1)
			Else 
				[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate(2)
			End if 
			
		: ($Gross<[Cost_Centers:27]RS_SplTo:51)  //small jobs get diffecult rate
			[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate(1)
			
		: ($diffRun)
			[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate(1)
			
		: ($easyRun)
			[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate(3)
			If ([Estimates_Machines:20]FormChangeHere:9)  //10/17/01 make this subform aware
				[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]RunningRate:31*[Cost_Centers:27]RS_reduction1:53
			End if 
			
		Else 
			[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate(2)  //$normRun `default to normal
			If ([Estimates_Machines:20]FormChangeHere:9)  //10/17/01 make this subform aware
				[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]RunningRate:31*[Cost_Centers:27]RS_reduction1:53
			End if 
	End case 
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