//%attributes = {"publishedWeb":true}
//fCalcStamping()   -JML  8/3/93, mlb 11/9/93, 1/21/94,3/28/94
//451 Bobst Stamping-Computer Calculation
// • mel (6/16/05, 10:30:56) refactor and add testrate mr method

C_LONGINT:C283($1; $waste; $net; $gross; $0; $runRate; $DieChanges)
C_REAL:C285($MR_hrs; $flat; $embossed; $combo)
C_BOOLEAN:C305($2; $isFilmLam)
C_TEXT:C284($ppcMR; $ppcRR)

$net:=PlannedNet  // to match HP kluge style waste calculation
$DieChanges:=[Estimates_Machines:20]Flex_Field7:38
$isFilmLam:=$2
//WASTE
$Waste:=fCalcStdWaste($Net)
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste
fCalcEFCUnits
// If (False)  `only used in manual calculation-this is computer version.
//   If (Position("over Acetate";[PROCESS_SPEC]LeafColor1) | 
//   Position("over Acetate";[PROCESS_SPEC]LeafColor2)
//   | Position("over Acetate";[PROCESS_SPEC]LeafColor3))
//  $Acetate:=True
//  End if 
//End if 

//MAKE READY
If ([Estimates_Machines:20]MR_Override:26#0) & (bTestRates=0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	
	$MR_hrs:=[Cost_Centers:27]MR_perSomething:34
	If (bTestRates=0)  //old way
		Case of   //per position coverage
			: (vCoverage<=[Cost_Centers:27]RS_shortTo:45)
				$ppcMR:=String:C10([Cost_Centers:27]MR_forSomething:35; "000000000")
			: (vCoverage<=[Cost_Centers:27]RS_MediumTo:47)
				$ppcMR:=String:C10([Cost_Centers:27]MR_addition:36; "000000000")
			: (vCoverage<=[Cost_Centers:27]RS_LongTo:49)
				$ppcMR:=String:C10([Cost_Centers:27]MR_reduction:37; "000000000")
			Else 
				BEEP:C151
				Est_LogIt("ERROR:"+"Coverages must be less than or equal to "+String:C10([Cost_Centers:27]RS_LongTo:49)+"% on the "+[Cost_Centers:27]ID:1)
				$ppcMR:="__ERROR__"
		End case 
		$flat:=Num:C11(Substring:C12($ppcMR; 1; 3))/100
		$embossed:=Num:C11(Substring:C12($ppcMR; 4; 3))/100
		$combo:=Num:C11(Substring:C12($ppcMR; 7; 3))/100
		If (($flat+$embossed+$combo)=0)
			BEEP:C151
			Est_LogIt("WARNING: "+"See Department Manager for MR override time.")
		End if 
		$MR_hrs:=$MR_hrs+($flat*vUnitsFlat)
		$MR_hrs:=$MR_hrs+($embossed*vUnitsEmbos)
		$MR_hrs:=$MR_hrs+($combo*vUnitsCombo)
		
		$MR_hrs:=$MR_hrs+([Cost_Centers:27]Field58:58*$DieChanges)
		
	Else   // • mel (6/16/05, 10:30:56) refactor and add testrate mr method
		$MR_hrs:=$MR_hrs+([Cost_Centers:27]MR_forSomething:35*vUnitsFlat)
		$MR_hrs:=$MR_hrs+([Cost_Centers:27]MR_addition:36*vUnitsEmbos)
		$MR_hrs:=$MR_hrs+([Cost_Centers:27]MR_reduction:37*vUnitsCombo)
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
	If (bTestRates=0)  // else set in CostCtr_RunHrsTransient
		Case of   //per position coverage
			: (vCoverage<=[Cost_Centers:27]RS_shortTo:45)
				$ppcRR:=String:C10([Cost_Centers:27]RS_short:46; "000000000")
			: (vCoverage<=[Cost_Centers:27]RS_MediumTo:47)
				$ppcRR:=String:C10([Cost_Centers:27]RS_Medium:48; "000000000")
			: (vCoverage<=[Cost_Centers:27]RS_LongTo:49)
				$ppcRR:=String:C10([Cost_Centers:27]RS_Long:50; "000000000")
			Else 
				BEEP:C151
				Est_LogIt("ERROR:"+"Coverages must be less than or equal to "+String:C10([Cost_Centers:27]RS_LongTo:49)+"% on the "+[Cost_Centers:27]ID:1)
				$ppcRR:="__ERROR__"
		End case 
		
		Case of   //use the lowest runrate
			: (vUnitsCombo#0)
				$position:=7
			: (vUnitsEmbos#0)
				$position:=4
			: (vUnitsFlat#0)
				$position:=1
			Else 
				Est_LogIt("WARNING: "+"Error: missing number Flat, Embossed, or Combo on the "+[Cost_Centers:27]ID:1)
				$position:=7
		End case 
		
		$runRate:=Num:C11(Substring:C12($ppcRR; $position; 3))*10
		If ($runRate=0)
			Est_LogIt("WARNING: "+"Stamping run rate of zero on the "+[Cost_Centers:27]ID:1)
		End if 
		
		If ($isFilmLam)
			$runRate:=$runRate*(1-([Cost_Centers:27]RS_reduction1:53/100))
		End if 
		
		[Estimates_Machines:20]RunningRate:31:=$runRate
	End if 
End if   //override

fCalcStdTotals($Gross; $Waste; $Net)
$0:=$gross