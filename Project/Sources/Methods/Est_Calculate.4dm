//%attributes = {"publishedWeb":true}
//PM:  Est_Calculate()  9/13/99  MLB
//formerly  `sRunEstAll     Calc btn  Estimate.input -JML  

//$1 optional, skips dialog asking which differentials to calculate
//causes all differentials to be calculated

//This allows user to choose the Differentials to calculate.  The computer
//will then redo those calculations.

//get Diff Picks from user
//loop thru diffs
//for each diff, recalculate all forms
//add up Diff Totals
//calculate Item costs
// •9/30/93, mod mlb 11.12.93
// •modified by Chip   -12/13/94 upr 1234
//•modified by mlb   -3/30/95  elim dio if only one diff
//•073098  MLB  UPR 1966 New Allocation
//•9/14/99  MLB  overhaul
// Modified by: Mel Bohince (6/3/21)  CostCtrCurrent param 3 is now a pointer

C_BOOLEAN:C305(<>fContinue)
C_LONGINT:C283($numDifferentials; $i; $j; $numForms; $numCalcs; $progress)
ARRAY TEXT:C222(aMHRname; 1)  //•090399  mlb  UPR 2052
ARRAY TEXT:C222(asDiff; 0)
ARRAY TEXT:C222(asDiffid; 0)
ARRAY TEXT:C222(asBull; 0)
ARRAY LONGINT:C221(aRecNo; 0)

MESSAGES OFF:C175
zCursorMgr("beachBallOff")
zCursorMgr("watch")

<>fContinue:=True:C214
ON EVENT CALL:C190("eCancelProc")

//there was a time that 3 different rates were considered, but only one made it
aMHRname{1}:="Sales"
aMHRname:=1

CUT NAMED SELECTION:C334([Estimates_Carton_Specs:19]; "holdCartons")  //•9/14/99  MLB  UPR 
CUT NAMED SELECTION:C334([Estimates_Differentials:38]; "holdDiffs")  //•9/14/99  MLB  UPR 

If (Count parameters:C259=0)
	Est_LogIt("init")
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)
	SELECTION TO ARRAY:C260([Estimates_Differentials:38]; aRecNo; [Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff; [Estimates_Differentials:38]diffNum:3; asDiffid)
	SORT ARRAY:C229(asDiffid; asDiff; aRecNo; >)
	
	$numDifferentials:=Size of array:C274(asDiff)
	ARRAY TEXT:C222(asBull; $numDifferentials)
	ARRAY BOOLEAN:C223(ListBox1; $numDifferentials)
	$winRef:=OpenSheetWindow(->[zz_control:1]; "EstDiff_Calc")
	DIALOG:C40([zz_control:1]; "EstDiff_Calc")
	CLOSE WINDOW:C154
	
Else 
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]estimateNum:2=[Estimates:17]EstimateNo:1)  //get existing differentials
	SELECTION TO ARRAY:C260([Estimates_Differentials:38]; aRecNo; [Estimates_Differentials:38]PSpec_Qty_TAG:25; asDiff)
	asDiff:=0
	$numDifferentials:=Size of array:C274(asDiff)
	ARRAY TEXT:C222(asBull; $numDifferentials)
	For ($i; 1; $numDifferentials)  //fill array as if user had selected everything
		asBull{$i}:="•"
	End for 
	OK:=1  //pass through as if user had OKed Dlog
End if 

Est_LogIt("Begin estimate calculation at "+TS2String(TSTimeStamp); 0)
Est_LogIt("VVVVVVVVVVVVVVVVVVVVVVVVVVV"; 0)
READ ONLY:C145([Cost_Centers:27])  //4/5/95
If (OK=1)
	//*Init CostCtr Info
	If (bTestRates=0)  // Modified by: Mel Bohince (6/3/21)  CostCtrCurrent param 3 is now a pointer
		Est_LogIt("Using current "+aMHRname{aMHRname}+" rates."; 0)
		CostCtrCurrent("init"; "00/00/00")  //;aMHRname{aMHRname})  //•073098  MLB  UPR 1966
	Else 
		Est_LogIt("WARNING: Using test "+aMHRname{aMHRname}+" rates."; 0)
		CostCtrCurrent("init"; "09/01/1991")  //;aMHRname{aMHRname})  //•073098  MLB  UPR 1966
		BEEP:C151
		zwStatusMsg("ALERT"; "Test OOP MHR Standards with an effectivity of 09/01/1991")
	End if 
	$numCalcs:=0  // Modified by: Mel Bohince (6/9/21) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numCalcs)
	QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=([Estimates:17]EstimateNo:1+"@"))
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	$progress:=0
	
	uThermoInit($numCalcs; "Forms to calculate on estimate "+[Estimates:17]EstimateNo:1)
	uThermoUpdate(0; 1)
	READ WRITE:C146([Estimates_Differentials:38])
	For ($i; 1; $numDifferentials)
		GOTO RECORD:C242([Estimates_Differentials:38]; aRecNo{$i})  //get Diff record
		//• mlb - 10/25/02  14:34 change stat from new
		PSPEC_SetStatus(([Estimates:17]Cust_ID:2+":"+[Estimates_Differentials:38]ProcessSpec:5); "Estimated")
		RELATE MANY:C262([Estimates_Differentials:38]Id:1)  //Find all forms for this diff 
		$numForms:=Records in selection:C76([Estimates_DifferentialsForms:47])
		
		If (asBull{$i}#"")
			Est_LogIt("Calculating Differential "+[Estimates_Differentials:38]diffNum:3+" - "+[Estimates_Differentials:38]PSpec_Qty_TAG:25)
			//*   Get the cartons being quoted
			$numCartons:=Est_CollectionCartons("Load"; [Estimates:17]EstimateNo:1; [Estimates_Differentials:38]diffNum:3)
			estCalcError:=False:C215
			ORDER BY:C49([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]FormNumber:2; >)  // Modified by: Mel Bohince (8/1/16) 
			
			For ($j; 1; $numForms)
				Est_LogIt("\r••••  FORM: "+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")+"  ••••")
				Est_FormCostsCalculation
				NEXT RECORD:C51([Estimates_DifferentialsForms:47])
				$progress:=1+$progress
				uThermoUpdate($progress; 1)
			End for 
			
			Est_DifferencialCostsRollup  //totals for Differential
			
			If (<>fContinue)
				If (<>NewAlloccat)  //•072998  MLB  UPR 1966
					Est_CartonCostAllocationNew  //get rid of thermoint!
				Else 
					Est_CartonCostAllocationOld
				End if 
			End if 
			
			$err:=Est_CollectionCartons("Clear")
			
		Else 
			$progress:=$numForms+$progress
			uThermoUpdate($progress; 1)
		End if 
		
	End for 
	uThermoClose
	//*destroy CostCtr Info
	//CostCtrCurrent ("kill")  //•073098  MLB  UPR 1966  
	Est_LogIt("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"; 0)
	Est_LogIt("End estimate calculation at "+TS2String(TSTimeStamp); 0)
	If (Position:C15("Error"; tCalculationLog)>0)
		BEEP:C151
		BEEP:C151
		BEEP:C151
		Est_LogIt("ERROR ENCOUNTERED, CHECK THE LOG")
	End if 
	If (Position:C15("WARN"; tCalculationLog)>0)
		BEEP:C151
		BEEP:C151
		Est_LogIt("WARNING ENCOUNTERED, CHECK THE LOG")
	End if 
	
	If (Count parameters:C259=0)
		Est_LogIt("show")
		Est_LogIt("init")
	End if 
End if 

USE NAMED SELECTION:C332("holdCartons")  //•9/14/99  MLB  UPR 
USE NAMED SELECTION:C332("holdDiffs")  //•9/14/99  MLB  UP
ON EVENT CALL:C190("")
zCursorMgr("restore")