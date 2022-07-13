//%attributes = {"publishedWeb":true}
//PM:  Est_ChangeRatesstimate+differencial;rateType)  100499  mlb
//recalculate an estimate base on different rates.
// Modified by: Mel Bohince (6/3/21)  CostCtrCurrent param 3 is now a pointer

MESSAGES OFF:C175

zCursorMgr("beachBallOff")
zCursorMgr("watch")

READ WRITE:C146([Estimates_Differentials:38])
READ WRITE:C146([Estimates_DifferentialsForms:47])
READ WRITE:C146([Estimates_Machines:20])
READ WRITE:C146([Estimates_Carton_Specs:19])
READ WRITE:C146([Estimates_Differentials:38])
READ ONLY:C145([Estimates_Materials:29])

Est_LogIt("init")

//*get target estimate and differencial
If (Count parameters:C259>=2)
	$estimate:=$1
	$mhrType:=$2
	If (Count parameters:C259>=2)
		$singleEst:=True:C214
	Else 
		$singleEst:=False:C215
	End if 
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$estimate)
Else 
	Repeat 
		REDUCE SELECTION:C351([Estimates_Differentials:38]; 0)
		$estimate:=Request:C163("EstimateDif (1-1234.12AB): ")
		If (OK=1)
			QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$estimate)
		End if 
	Until (Records in selection:C76([Estimates_Differentials:38])=1) | (OK=0)
	If (Records in selection:C76([Estimates_Differentials:38])=1)
		$mhrType:=Request:C163("MHR (Sales/Haup/Roan): ")
		$singleEst:=True:C214
	End if 
End if 

If (Records in selection:C76([Estimates_Differentials:38])=1)
	Est_LogIt("Estimate: "+$estimate+" set to "+$mhrType+" MHR")
	
	//*init the cost centers if required
	If ($singleEst)
		CostCtrCurrent("init"; "00/00/00")  //;$mhrType)// Modified by: Mel Bohince (6/3/21)  param 3 is now a pointer
	End if 
	
	TRACE:C157
	//*Get the materials so there cost can be rolled
	QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=($estimate+"@"))
	//*Get the operations so they may be recalc at diff rate
	QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=($estimate+"@"))
	$numSeq:=Records in selection:C76([Estimates_Machines:20])
	uThermoInit($numSeq; "Change MHR rates")
	For ($i; 1; $numSeq)  //*For each operation
		If (Not:C34([Estimates_Machines:20]OutSideService:33))
			$CC:=[Estimates_Machines:20]CostCtrID:4
			Est_LogIt($CC+" from "+String:C10([Estimates_Machines:20]CostOOP:28))
			//*    get the cc's rates
			[Estimates_Machines:20]LaborStd:7:=CostCtrCurrent("Labor"; $CC)  //[COST_CENTER]MHRlaborSales  `•090799  mlb  UPR 2052
			[Estimates_Machines:20]OverheadStd:8:=CostCtrCurrent("Burden"; $CC)  //[COST_CENTER]MHRburdenSales  `•090799  mlb  UPR 2052
			[Estimates_Machines:20]OOPStd:17:=[Estimates_Machines:20]LaborStd:7+[Estimates_Machines:20]OverheadStd:8  //•071296  MLB  
			//[Machine_Est]Effectivity:=[COST_CENTER]EffectivityDate
			//*    get the hours
			$hrs:=[Estimates_Machines:20]RunningHrs:32+[Estimates_Machines:20]MakeReadyHrs:30
			//*    recalc the costs
			[Estimates_Machines:20]CostLabor:13:=$hrs*[Estimates_Machines:20]LaborStd:7
			[Estimates_Machines:20]CostOverhead:15:=$hrs*[Estimates_Machines:20]OverheadStd:8
			[Estimates_Machines:20]CostOOP:28:=Round:C94(([Estimates_Machines:20]CostOverhead:15+[Estimates_Machines:20]CostLabor:13); 0)
			Est_LogIt("     "+" to      "+String:C10([Estimates_Machines:20]CostOOP:28))
			[Estimates_Machines:20]CostLabor:13:=Round:C94([Estimates_Machines:20]CostLabor:13; 0)
			[Estimates_Machines:20]CostOverhead:15:=Round:C94([Estimates_Machines:20]CostOverhead:15; 0)
			//
			[Estimates_Machines:20]CostScrap:12:=Round:C94(($hrs*CostCtrCurrent("Scrap"; [Estimates_Machines:20]CostCtrID:4)); 2)
			
			If ([Estimates_Machines:20]CalcOvertimeFlg:42)
				[Estimates_Machines:20]CostOvertime:41:=Round:C94(([Estimates_Machines:20]CostLabor:13*0.5); 2)
			Else 
				[Estimates_Machines:20]CostOvertime:41:=0
			End if 
			SAVE RECORD:C53([Estimates_Machines:20])
		End if 
		NEXT RECORD:C51([Estimates_Machines:20])
		uThermoUpdate($i)
	End for 
	uThermoClose
	
	//*Rollup the form costs
	QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3=($estimate+"@"))
	For ($i; 1; Records in selection:C76([Estimates_DifferentialsForms:47]))
		Est_FormCostsRollup
		SAVE RECORD:C53([Estimates_DifferentialsForms:47])
		NEXT RECORD:C51([Estimates_DifferentialsForms:47])
	End for 
	
	//*Roll up the differencial costs
	If (False:C215)
		Est_DifferencialCostsRollup
	Else 
		QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$estimate)
		[Estimates_Differentials:38]CostTtlLabor:11:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]CostTtlLabor:15))
		[Estimates_Differentials:38]CostTtlOH:12:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]CostTtlOH:16))
		[Estimates_Differentials:38]CostTtlMatl:13:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]CostTtlMatl:17))
		[Estimates_Differentials:38]Cost_Overtime:17:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]Cost_Overtime:25))
		[Estimates_Differentials:38]Cost_Scrap:15:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]Cost_Scrap:24))
		Est_LogIt("[Differential]CostTTL"+" from "+String:C10([Estimates_Differentials:38]CostTTL:14))
		[Estimates_Differentials:38]CostTTL:14:=uNANCheck([Estimates_Differentials:38]CostTtlMatl:13+[Estimates_Differentials:38]CostTtlOH:12+[Estimates_Differentials:38]CostTtlLabor:11+[Estimates_Differentials:38]Cost_Scrap:15+[Estimates_Differentials:38]Cost_RD:16+[Estimates_Differentials:38]Cost_Overtime:17)
		Est_LogIt("                        "+" to      "+String:C10([Estimates_Differentials:38]CostTTL:14))
	End if 
	
	//*Alocate cost to the cartons
	If (<>NewAlloccat)  //•072998  MLB  UPR 1966
		Est_CartonCostAllocationNew  //get rid of thermoint!
	Else 
		If (False:C215)
			Est_CartonCostAllocationOld
		Else 
			$otCost:=[Estimates_Differentials:38]Cost_Overtime:17
			$laborCost:=[Estimates_Differentials:38]CostTtlLabor:11+$otCost  //•042397  MLB 
			$burdonCost:=[Estimates_Differentials:38]CostTtlOH:12
			$matlCost:=[Estimates_Differentials:38]CostTtlMatl:13
			$scrapCost:=[Estimates_Differentials:38]Cost_Scrap:15
			$totalCost:=$laborCost+$burdonCost+$matlCost+$scrapCost
			$numCartons:=Est_CollectionCartons("Load"; [Estimates_Differentials:38]estimateNum:2; [Estimates_Differentials:38]diffNum:3)
			$allocation:=0
			For ($i; 1; $numCartons)
				$allocation:=$allocation+aAllocPct{$i}
			End for 
			If ($allocation<98)
				$TotalSqIn:=Est_CalcAllocPercent([Estimates_Differentials:38]estimateNum:2; [Estimates_Differentials:38]diffNum:3)
			End if 
			$err:=Est_CollectionCartons("Store"; "Cost"; ""; $matlCost; ->[Estimates_Carton_Specs:19]CostMatl_Per_M:66)
			$err:=Est_CollectionCartons("Store"; "Cost"; ""; $laborCost; ->[Estimates_Carton_Specs:19]CostLabor_Per_M:64)
			$err:=Est_CollectionCartons("Store"; "Cost"; ""; $burdonCost; ->[Estimates_Carton_Specs:19]CostOH_Per_M:65)
			$err:=Est_CollectionCartons("Store"; "Cost"; ""; $scrapCost; ->[Estimates_Carton_Specs:19]CostScrap_Per_M:67)
			$err:=Est_CollectionCartons("Store"; "Cost"; ""; $totalCost; ->[Estimates_Carton_Specs:19]CostWant_Per_M:25)
		End if 
	End if 
	
	//*Tear down
	If ($singleEst)
		//CostCtrCurrent ("kill")  //•073098  MLB  UPR 1966  
	End if 
	
	Est_LogIt("show")
	Est_LogIt("init")
End if 