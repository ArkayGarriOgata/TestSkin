//%attributes = {"publishedWeb":true}
//fCalcGravure()     -JML      8/3/93 , mod mlb 11.11.93
//427 Gravure & Air knife
//4/5/95 add spl width threshold warning
//• mlb - 5/15/02  11:36 add for Color Standard

C_LONGINT:C283($1; $waste; $net; $gross; $0; $6)
C_REAL:C285($MR_hrs; $3; $Width; $4; $Length; $LinearFeet)
C_LONGINT:C283($ColorTotal)
C_BOOLEAN:C305($usingFoil; $2)
C_BOOLEAN:C305($airKnife; $5)
C_BOOLEAN:C305($Gravure)

$net:=PlannedNet  // to match HP kluge style waste calculation  
$Gravure:=False:C215
$airKnife:=$5
$Length:=$4
$Width:=$3
$UsingFoil:=$2
$numGravure:=$6

//determine Gravure colors & usage of from the [machine_est]flex_field1.  If
//vaslue is 0, gravure is not in use.  Same logic applies for Airknife, but use
//[machine_est]flex_field2.

//I know the following code is inefficient & ugly -- but you're ugly too.
If ([Estimates_Machines:20]Flex_field1:18>0)
	$ColorTotal:=[Estimates_Machines:20]Flex_field1:18  //color total is same as gravur color total, supposedly
Else 
	$ColorTotal:=$numGravure  //color total is same as gravur color total, supposedly
End if 
$ColorTtlAir:=Num:C11($airKnife)
$ColorTtlGra:=$ColorTotal
$Gravure:=($ColorTtlGra>0)

If (($Gravure=False:C215) & ($AirKnife=False:C215))
	vFailed:=True:C214
	ALERT:C41("At least on of these two operations must be specified: Gravure and/or Air Knife.")
Else 
	If ($ColorTtlAir>1)
		ALERT:C41("Sorry, but the air knife can only have a color total of 0 or 1.")
		vFailed:=True:C214
	Else 
		
		//WASTE
		$waste:=0
		$waste:=$waste+($net*([Cost_Centers:27]WA_running1:20/100))
		$waste:=$waste+([Cost_Centers:27]WA_perSomething:31*$ColorTotal)
		If ($waste<[Cost_Centers:27]WA_min:18)
			$waste:=[Cost_Centers:27]WA_min:18
		End if 
		If ([Estimates_Machines:20]WasteAdj_Percen:40>0)
			$waste:=([Estimates_Machines:20]WasteAdj_Percen:40/100)*$Waste
		End if 
		$net:=$1  // to recover from HP kluge style waste calculation
		$gross:=$net+$waste
		
		//MAKE READY
		$MR_hrs:=0
		If ($Gravure)
			$MR_hrs:=$MR_Hrs+([Cost_Centers:27]MR_perSomething:34*$ColorTotal)
		End if 
		If ($airKnife)
			$MR_hrs:=$MR_Hrs+[Cost_Centers:27]MR_forSomething:35
		End if 
		If ($MR_hrs<[Cost_Centers:27]MR_mimumum:33)
			$MR_hrs:=[Cost_Centers:27]MR_mimumum:33
		End if 
		If ([Estimates_Machines:20]MR_Override:26#0)
			[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
		Else 
			[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
		End if 
		
		//RUNNING RATE 
		If ([Estimates_Machines:20]Run_Override:27#0)
			[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
		Else 
			Case of   //these seem to be in conflict-last 3 cases will never get executed
				: ($Gravure & $airKnife)
					[Estimates_Machines:20]RunningRate:31:=14000
				: ($AirKnife)
					[Estimates_Machines:20]RunningRate:31:=16300
				: ($Gravure)
					[Estimates_Machines:20]RunningRate:31:=14000
			End case 
			If ($usingFoil)
				[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]RunningRate:31*(1-([Cost_Centers:27]RS_reduction1:53/100))
			End if 
		End if 
		
		If ([Estimates_DifferentialsForms:47]ColorStdSheets:34#0)  //• mlb - 5/15/02  11:36 add for Color Standard
			$Gross:=$Gross+[Estimates_DifferentialsForms:47]ColorStdSheets:34
		End if 
		$LinearFeet:=$Gross*$length/12
		
		fCalcStdTotals($Gross; $Waste; $net; $LinearFeet)
		$0:=$gross
	End if 
End if 