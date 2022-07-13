//%attributes = {"publishedWeb":true}
//461, 465  fCalcBobst      Bobst Die Cutting & Blanking
//mod mlb 1/21/94
//•042999  MLB  UPR 1947

C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs)
C_BOOLEAN:C305($2; $CartonStrip; $StripUnit; $RepeatForm; $isFilmLam; $3; $4; $isInline; $5; $isDieCut)

$CartonStrip:=$2
$isFilmLam:=$3
$isInline:=$4
$isDieCut:=$5
//$net:=$1  ` equals last gross
$net:=PlannedNet  // to match HP kluge style waste calculation

//If ([COST_CENTER]ID="461") | ([COST_CENTER]ID="462")  `•042999  MLB  UPR 1947
$StripUnit:=[Estimates_Machines:20]Flex_Field5:25
$RepeatForm:=[Estimates_Machines:20]Flex_field6:37
//Else 
//$StripUnit:=False
//$RepeatForm:=[Machine_Est]Flex_Field5
//End if 

//WASTE  
$Waste:=fCalcStdWaste($Net)
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
If ([Estimates_Machines:20]MR_Override:26#0) & (bTestRates=0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	$MR_hrs:=0
	
	If ($RepeatForm)
		$MR_hrs:=[Cost_Centers:27]MR_forSomething:35
	Else 
		$MR_hrs:=[Cost_Centers:27]MR_perSomething:34
	End if 
	
	If ($StripUnit)
		$MR_hrs:=$MR_hrs+[Cost_Centers:27]MR_addition:36
	End if 
	
	If ($MR_hrs<[Cost_Centers:27]MR_mimumum:33)
		$MR_hrs:=[Cost_Centers:27]MR_mimumum:33
	End if 
	
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	[Estimates_Machines:20]RunningRate:31:=fCalcDoRunRate($Gross; $isFilmLam)
End if 

If (($isInline & $isDieCut) & (([Estimates_Machines:20]Run_Override:27=0) | ([Estimates_Machines:20]MR_Override:26=0)))
	Est_LogIt("WARNINGSee Department Head for MR and Running Speeds on "+"461 and 465 if D/C and Inline.")
End if 

fCalcStdTotals($gross; $Waste; $net)
$0:=$gross
//return last gross