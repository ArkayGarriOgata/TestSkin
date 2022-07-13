//%attributes = {"publishedWeb":true}
//fCalcBobEmboss()   -JML  8/4/93
//463                         mod mlb 1/21/94

C_LONGINT:C283($1; $waste; $net; $gross; $0)
C_REAL:C285($MR_hrs; $moreWaste)
C_BOOLEAN:C305($nonRegister; $4; $2; $3; $isfitted; $isFilmLam; $5; $isInline; $6; $isDieCut)

//$net:=$1  ` equals last gross
$net:=PlannedNet  // to match HP kluge style waste calculation
$isfitted:=$2
$isFilmLam:=$3
$nonRegister:=$4
$isInline:=$5
$isDieCut:=$6

//it is possible the NonRegister & Fitted Register are exact opposites(either/or)
//if so we will combine the check boxes: [PROCESS_SPEC]EmbossFitted 
//& [PROCESS_SPEC]EmbossNonRegis
fCalcEFCUnits  //determines # of flat, emboss, & combo units an Per position coverage
//WASTE  
$Waste:=fCalcStdWaste($Net)
$moreWaste:=0  //••••••• this zeros out all the extra shit, why? 4/13/00  mlb  
If ($nonRegister)
	$moreWaste:=$moreWaste*(1-([Cost_Centers:27]WA_perSomething:31/100))
End if 

If ($isFilmLam)
	$moreWaste:=$moreWaste*(1+([Cost_Centers:27]Field56:56/100))
End if 

If ([Estimates_Machines:20]WasteAdj_Percen:40>0)
	$moreWaste:=([Estimates_Machines:20]WasteAdj_Percen:40/100)*$moreWaste
End if 
$Waste:=$Waste+$moreWaste
$net:=$1  // to recover from HP kluge style waste calculation
$gross:=$net+$waste

//MAKE READY
If ([Estimates_Machines:20]MR_Override:26#0) & (bTestRates=0)
	[Estimates_Machines:20]MakeReadyHrs:30:=[Estimates_Machines:20]MR_Override:26
Else 
	$MR_hrs:=[Cost_Centers:27]MR_mimumum:33
	$Mr_hrs:=$Mr_hrs+([Cost_Centers:27]MR_perSomething:34*vUnitsEmbos)
	[Estimates_Machines:20]MakeReadyHrs:30:=$MR_hrs
End if 

//RUNNING RATE
If ([Estimates_Machines:20]Run_Override:27#0)
	[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]Run_Override:27
Else 
	If ($NonRegister)
		[Estimates_Machines:20]RunningRate:31:=[Cost_Centers:27]RS_short:46
	Else 
		[Estimates_Machines:20]RunningRate:31:=[Cost_Centers:27]RS_Medium:48
	End if 
	If ($isFilmLam)
		[Estimates_Machines:20]RunningRate:31:=[Estimates_Machines:20]RunningRate:31*(1-([Cost_Centers:27]RS_reduction1:53/100))
	End if 
End if 

If (($isInline & $isDieCut) & (([Estimates_Machines:20]Run_Override:27=0) | ([Estimates_Machines:20]MR_Override:26=0)))
	BEEP:C151
	ALERT:C41("See Department Head for MR and Running Speeds on 463 if D/C and Inline.")
End if 

fCalcStdTotals($Gross; $Waste; $net)
$0:=$gross
//return last gross