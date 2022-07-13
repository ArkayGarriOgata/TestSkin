//%attributes = {"publishedWeb":true}
//fCalcDieMake   442 Die making mlb 11/11/93
//mod 3/23/94 upr1043
//11/21/94 total OOP cost

C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs)
C_BOOLEAN:C305($stripUnit; $CartonStrip; $2; $BlankUnit)

$StripUnit:=[Estimates_Machines:20]Flex_Field5:25
$BlankUnit:=[Estimates_Machines:20]Flex_field6:37
$CartonStrip:=False:C215  //$2
//$net:=$1  ` equals last gross
$net:=PlannedNet  // to match HP kluge style waste calculation

//also use arrays defined in sRunEstimate:
//ARRAY TEXT(sDieCutOpt;records in formcarton selection)
//ARRAY LONGINT(iNumUp;records in formcarton selection)
//WASTE
$waste:=0
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
//$MR_hrs:=[COST_CENTER]MR_mimumum
$MR_hrs:=0
If ($BlankUnit)
	$MR_hrs:=$MR_hrs+[Cost_Centers:27]MR_mimumum:33
Else 
	If ($StripUnit | $CartonStrip)
		$MR_hrs:=$MR_hrs+[Cost_Centers:27]MR_forSomething:35
	End if 
End if 

For ($i; 1; Size of array:C274(sDieCutOpt))  //look for striping unit
	If (iNumUp{$i}>1)  //           assume at least 1 up
		$break1:=iNumUp{$i}-1  //33% reduction of additional 5 ups of same item
		If ($break1>5)  //25% additional reduction of over 5 additional ups of same item over 5 items
			$break2:=$break1-5
			$break1:=5
		Else 
			$break2:=0
		End if 
	Else 
		$break1:=0
		$break2:=0
	End if 
	
	Case of 
		: (sDieCutOpt{$i}="Straight")
			$MR_hrs:=$MR_hrs+[Cost_Centers:27]Field56:56  // the first up
			$MR_hrs:=$MR_hrs+(([Cost_Centers:27]Field56:56*(1-([Cost_Centers:27]MR_addition:36/100)))*($break1))
			$MR_hrs:=$MR_hrs+(([Cost_Centers:27]Field56:56*(1-(([Cost_Centers:27]MR_addition:36+[Cost_Centers:27]MR_reduction:37)/100)))*($break2))
			
		: ((sDieCutOpt{$i}="Sleeves") | (sDieCutOpt{$i}="Vial"))
			$MR_hrs:=$MR_hrs+[Cost_Centers:27]Field57:57  // the first up
			$MR_hrs:=$MR_hrs+(([Cost_Centers:27]Field57:57*(1-([Cost_Centers:27]MR_addition:36/100)))*($break1))
			$MR_hrs:=$MR_hrs+(([Cost_Centers:27]Field57:57*(1-(([Cost_Centers:27]MR_addition:36+[Cost_Centers:27]MR_reduction:37)/100)))*($break2))
			
			
		: (sDieCutOpt{$i}="Multifold")
			$MR_hrs:=$MR_hrs+[Cost_Centers:27]Field58:58  // the first up
			$MR_hrs:=$MR_hrs+(([Cost_Centers:27]Field58:58*(1-([Cost_Centers:27]MR_addition:36/100)))*($break1))
			$MR_hrs:=$MR_hrs+(([Cost_Centers:27]Field58:58*(1-(([Cost_Centers:27]MR_addition:36+[Cost_Centers:27]MR_reduction:37)/100)))*($break2))
			
		Else   //default to straight
			$MR_hrs:=$MR_hrs+[Cost_Centers:27]Field56:56  // the first up
			$MR_hrs:=$MR_hrs+(([Cost_Centers:27]Field56:56*(1-([Cost_Centers:27]MR_addition:36/100)))*($break1))
			$MR_hrs:=$MR_hrs+(([Cost_Centers:27]Field56:56*(1-(([Cost_Centers:27]MR_addition:36+[Cost_Centers:27]MR_reduction:37)/100)))*($break2))
	End case 
End for 

If ([Estimates_Machines:20]MR_Override:26#0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
End if 

fCalcStdTotals($Gross; $Waste; $net)

$0:=$gross  //return last gross