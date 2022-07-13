//%attributes = {"publishedWeb":true}
//fCalcSheeter()    -JML    8/3/93 mod mlb 11.11.93, 3/23/94
//426 Sheeter
//• mlb - 5/15/02  11:36 add for Color Standard
// Modified by: Mel Bohince (7/29/16) add doublewide option for 429

C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs; $Width; $4; $Length; $5; $Caliper; $3; $LinearFeet)
C_BOOLEAN:C305($usingFoil; $2; $coating; $doubleWideRole)  //somehow this is derived from Planner input
C_POINTER:C301($6; $sheetsPerCut)

$net:=PlannedNet  // to match HP kluge style waste calculation
//WASTE
$waste:=0
$waste:=$waste+($net*([Cost_Centers:27]WA_running1:20/100))
If ($waste<[Cost_Centers:27]WA_min:18)
	$waste:=[Cost_Centers:27]WA_min:18
End if 
If ([Estimates_Machines:20]WasteAdj_Percen:40>0)
	$waste:=([Estimates_Machines:20]WasteAdj_Percen:40/100)*$Waste
End if 

$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste
$usingFoil:=$2
$Caliper:=$3
$Length:=$5
$Width:=$4
$sheetsPerCut:=$6
$doubleWideRole:=[Estimates_Machines:20]Flex_Field5:25  // Modified by: Mel Bohince (7/29/16) add doublewide option for 429
If ($doubleWideRole)
	$sheetsPerCut->:=2  // Modified by: Mel Bohince (10/5/16)
End if 
//MAKE READY
$MR_hrs:=[Cost_Centers:27]MR_mimumum:33+(Num:C11($Coating)*[Cost_Centers:27]MR_forSomething:35)
If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	//[Machine_Est]MakeReadyHrs:=util_roundUp ($MR_hrs)
	[Estimates_Machines:20]MakeReadyHrs:30:=Round:C94($MR_hrs; 2)
End if 

//RUNNING RATE  
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	Case of 
		: (($Length>0) & ($Length<25))
			[Estimates_Machines:20]RunningRate:31:=12000  //6000
			
		: (($Length>=25) & ($Length<=27))
			[Estimates_Machines:20]RunningRate:31:=14500  //6692
			
		: (($Length>27) & ($Length<30))
			[Estimates_Machines:20]RunningRate:31:=16600  //6989 
			
		: ($Caliper<=Round:C94(0.022; 4))  //30" and up and upto 22pt
			[Estimates_Machines:20]RunningRate:31:=18900  //7560 - 5670
			
		: ($Caliper>Round:C94(0.022; 4))  //30" and up and over 22pt
			[Estimates_Machines:20]RunningRate:31:=17500  //7000 - 5250
	End case 
	
	If ($usingFoil)
		[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]RunningRate:31*(1-([Cost_Centers:27]RS_reduction1:53/100))
	End if 
End if 

If ([Estimates_DifferentialsForms:47]ColorStdSheets:34#0)  //• mlb - 5/15/02  11:36 add for Color Standard
	$Gross:=$Gross+[Estimates_DifferentialsForms:47]ColorStdSheets:34
End if 
$LinearFeet:=$Gross*$length/12

If ($doubleWideRole)  // Modified by: Mel Bohince (7/29/16) add doublewide option for 429
	$LinearFeet:=$LinearFeet/$sheetsPerCut->
End if 

fCalcStdTotals($Gross; $Waste; $net; $LinearFeet)

$0:=$gross