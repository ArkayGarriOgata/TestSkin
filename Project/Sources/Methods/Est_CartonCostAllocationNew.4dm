//%attributes = {"publishedWeb":true}
//PM:  Est_CartonCostAllocationNew  091099  mlb
//formerly: sRunEstCrtnAllo()  see UPR 1966 072998  MLB
//based on sRunEstCartnCs3 
//called from sRunEstAll 
//now allocate fixed cost on particiaption and 
//allow targeting of spl costs to specific items

C_LONGINT:C283($i; $hit; $j; $recs)
C_REAL:C285($cartonSqIn; $PV; $totWantPric; $totYldPric; $breakouts; $rebate)  //•032797  MLB 

Est_LogIt("New Style' Carton Allocation")

//*ALLOCATION BASIS
//*   Get the cartons on this job for qty component of total sqin calc
QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=[Estimates_Differentials:38]Id:1+"@")  //3-0144.00AA...

ARRAY TEXT:C222($aFormCarton; 0)  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
ARRAY LONGINT:C221($aFormYldQty; 0)
ARRAY LONGINT:C221($aFormWntQty; 0)
SELECTION TO ARRAY:C260([Estimates_FormCartons:48]Carton:1; $aFormCarton; [Estimates_FormCartons:48]MakesQty:5; $aFormYldQty; [Estimates_FormCartons:48]FormWantQty:9; $aFormWntQty)  //8/26/94
//*   Get the cartons being quoted 
QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=[Estimates:17]EstimateNo:1; *)  //find Estimate Qty worksheet
QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=[Estimates_Differentials:38]diffNum:3)
ARRAY TEXT:C222($aCartonSpec; 0)
ARRAY REAL:C219($aSqIn; 0)
ARRAY LONGINT:C221($aCustWntQty; 0)
ARRAY TEXT:C222($aItemNumber; 0)
SELECTION TO ARRAY:C260([Estimates_Carton_Specs:19]CartonSpecKey:7; $aCartonSpec; [Estimates_Carton_Specs:19]SquareInches:16; $aSqIn; [Estimates_Carton_Specs:19]Quantity_Want:27; $aCustWntQty; [Estimates_Carton_Specs:19]Item:1; $aItemNumber)
//*   Calc the number of items on the job, for fixed allocation
$recs:=Size of array:C274($aCartonSpec)
$numberItems:=0
SORT ARRAY:C229($aCartonSpec; $aSqIn; $aCustWntQty; $aItemNumber; >)
ARRAY REAL:C219($aSplLaborFX; $recs)
ARRAY REAL:C219($aSplLaborVR; $recs)
ARRAY REAL:C219($aSplBurdFX; $recs)
ARRAY REAL:C219($aSplBurdVR; $recs)
ARRAY REAL:C219($aSplLaborYD; $recs)
ARRAY REAL:C219($aSplBurdYD; $recs)
ARRAY REAL:C219($aSplMatlFX; $recs)
ARRAY REAL:C219($aSplMatlVR; $recs)
ARRAY REAL:C219($aSplMatlYD; $recs)

$last:=""
For ($i; 1; $recs)
	If ($aCartonSpec{$i}#$last)
		$numberItems:=$numberItems+1
		$last:=$aCartonSpec{$i}
	End if 
End for 
If ($numberItems>0)  //continue
	//*   Calc the SqIn's on the job, for varible allocation
	$TotalSqIn:=0
	$TotalSqInYD:=0
	For ($i; 1; Size of array:C274($aFormCarton))  //calc total sqIn for the job
		$hit:=Find in array:C230($aCartonSpec; $aFormCarton{$i})
		If ($hit>-1)
			$TotalSqInYD:=$TotalSqInYD+($aSqIn{$hit}*$aFormYldQty{$i})
			If ($aCustWntQty{$hit}>0)  //upr 1250 don't include fill-ins
				If ($aFormWntQty{$i}=0)
					$TotalSqIn:=$TotalSqIn+($aSqIn{$hit}*$aCustWntQty{$hit})
				Else 
					$TotalSqIn:=$TotalSqIn+($aSqIn{$hit}*$aFormWntQty{$i})
				End if 
			End if 
		End if 
	End for 
	
	//*COSTS TO ALLOCATE
	If ($TotalSqInYD>0) & ($TotalSqIn>0)
		//*    Load the sequences so cost can be allocated differently
		ARRAY TEXT:C222($aCC; 0)
		ARRAY REAL:C219($aFixedHRs; 0)
		ARRAY REAL:C219($aVariHRs; 0)
		ARRAY REAL:C219($aYldHrs; 0)
		ARRAY TEXT:C222($aSplAlloc; 0)
		QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=([Estimates_Differentials:38]Id:1+"@"))
		SELECTION TO ARRAY:C260([Estimates_Machines:20]CostCtrID:4; $aCC; [Estimates_Machines:20]MakeReadyHrs:30; $aFixedHRs; [Estimates_Machines:20]RunningHrs:32; $aVariHRs; [Estimates_Machines:20]SplAllocate:39; $aSplAlloc; [Estimates_Machines:20]Hrs_YldAddition:44; $aYldHrs)
		
		//*    Split the Fixed, Variable, and Special Costs
		$laborFix:=0
		$laborVar:=0
		$burdenFix:=0
		$burdenVar:=0
		$laborYld:=0  //treat as variable
		$burdenYld:=0  //treat as variable
		$breakouts:=0  //cost associated with plates dups and dies
		
		For ($i; 1; Size of array:C274($aCC))
			$aSplAlloc{$i}:=Replace string:C233($aSplAlloc{$i}; " "; "")  //ignor spaces
			If (Length:C16($aSplAlloc{$i})=0)
				$laborFix:=$laborFix+(CostCtrCurrent("Labor"; $aCC{$i})*$aFixedHRs{$i})
				$laborVar:=$laborVar+(CostCtrCurrent("Labor"; $aCC{$i})*$aVariHRs{$i})
				$burdenFix:=$burdenFix+(CostCtrCurrent("Burden"; $aCC{$i})*$aFixedHRs{$i})
				$burdenVar:=$burdenVar+(CostCtrCurrent("Burden"; $aCC{$i})*$aVariHRs{$i})
				$laborYld:=$laborYld+(CostCtrCurrent("Labor"; $aCC{$i})*$aYldHrs{$i})
				$burdenYld:=$burdenYld+(CostCtrCurrent("Burden"; $aCC{$i})*$aYldHrs{$i})
				If (Position:C15($aCC{$i}; " 401 402 403 442 443 ")>0)
					$breakouts:=$breakouts+(CostCtrCurrent("Labor"; $aCC{$i})*$aFixedHRs{$i})+(CostCtrCurrent("Burden"; $aCC{$i})*$aFixedHRs{$i})
				End if 
				
			Else   //allocate all of this cost to the specified cartons
				$ilaborFix:=CostCtrCurrent("Labor"; $aCC{$i})*$aFixedHRs{$i}
				$ilaborVar:=CostCtrCurrent("Labor"; $aCC{$i})*$aVariHRs{$i}
				$iburdenFix:=CostCtrCurrent("Burden"; $aCC{$i})*$aFixedHRs{$i}
				$iburdenVar:=CostCtrCurrent("Burden"; $aCC{$i})*$aVariHRs{$i}
				$ilaborYld:=CostCtrCurrent("Labor"; $aCC{$i})*$aYldHrs{$i}
				$iburdenYld:=CostCtrCurrent("Burden"; $aCC{$i})*$aYldHrs{$i}
				If (Position:C15($aCC{$i}; " 401 402 403 442 443 ")>0)
					$breakouts:=$breakouts+(CostCtrCurrent("Labor"; $aCC{$i})*$aFixedHRs{$i})+(CostCtrCurrent("Burden"; $aCC{$i})*$aFixedHRs{$i})
				End if 
				//parse out the items and distribute costs
				$countitems:=0
				ARRAY TEXT:C222($aSplItems; $countitems)
				Repeat 
					$countitems:=$countitems+1
					ARRAY TEXT:C222($aSplItems; $countitems)
					$hit:=Position:C15(","; $aSplAlloc{$i})
					If ($hit=0)
						$hit:=Length:C16($aSplAlloc{$i})+1
					End if 
					$aSplItems{$countitems}:=Substring:C12($aSplAlloc{$i}; 1; $hit-1)
					$aSplAlloc{$i}:=Substring:C12($aSplAlloc{$i}; $hit+1)
				Until (Length:C16($aSplAlloc{$i})=0)
				$ilaborFix:=$ilaborFix/$countitems
				$ilaborVar:=$ilaborVar/$countitems
				$iburdenFix:=$iburdenFix/$countitems
				$iburdenVar:=$iburdenVar/$countitems
				$ilaborYld:=$ilaborYld/$countitems
				$iburdenYld:=$iburdenYld/$countitems
				//TRACE
				For ($j; 1; $countitems)
					$hit:=Find in array:C230($aItemNumber; $aSplItems{$j})
					If ($hit>-1)
						$aSplLaborFX{$hit}:=$aSplLaborFX{$hit}+$ilaborFix
						$aSplLaborVR{$hit}:=$aSplLaborVR{$hit}+$ilaborVar
						$aSplBurdFX{$hit}:=$aSplBurdFX{$hit}+$iburdenFix
						$aSplBurdVR{$hit}:=$aSplBurdVR{$hit}+$iburdenVar
						$aSplLaborYD{$hit}:=$aSplLaborYD{$hit}+$ilaborYld
						$aSplBurdYD{$hit}:=$aSplBurdYD{$hit}+$iburdenYld
					End if 
					
				End for 
				ARRAY TEXT:C222($aSplItems; 0)
			End if   //spl alloc
			
		End for 
		
		//*    Load the materials
		$matlFix:=0
		$matlVar:=0
		$matlYld:=0
		ARRAY REAL:C219($aMatlCost; 0)
		ARRAY REAL:C219($aMatlCostYD; 0)
		ARRAY TEXT:C222($aSplMatl; 0)
		ARRAY TEXT:C222($aComKey; 0)
		QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=([Estimates_Differentials:38]Id:1+"@"))
		SELECTION TO ARRAY:C260([Estimates_Materials:29]Cost:11; $aMatlCost; [Estimates_Materials:29]SplAllocate:29; $aSplMatl; [Estimates_Materials:29]Matl_YieldAdds:26; $aMatlCostYD; [Estimates_Materials:29]Commodity_Key:6; $aComKey)
		$recs:=Size of array:C274($aMatlCost)
		
		For ($i; 1; $recs)
			$aSplMatl{$i}:=Replace string:C233($aSplMatl{$i}; " "; "")  //ignor spaces
			If (Length:C16($aSplMatl{$i})=0)
				Case of 
					: ($aComKey{$i}="13-Laser Dies")
						$matlFix:=$matlFix+$aMatlCost{$i}+$aMatlCostYD{$i}
					: ($aComKey{$i}="04@")
						$matlFix:=$matlFix+$aMatlCost{$i}+$aMatlCostYD{$i}
					: ($aComKey{$i}="71@")
						$matlFix:=$matlFix+$aMatlCost{$i}+$aMatlCostYD{$i}
					: ($aComKey{$i}="07-Embossing@")
						$matlFix:=$matlFix+$aMatlCost{$i}+$aMatlCostYD{$i}
					Else 
						$matlVar:=$matlVar+$aMatlCost{$i}
						$matlYld:=$matlYld+$aMatlCostYD{$i}
				End case 
				
			Else   //allocate all of this cost to the specified cartons 
				$imatlFix:=0
				$imatlVar:=0
				$imatlYld:=0
				Case of 
					: ($aComKey{$i}="13-Laser Dies")
						$imatlFix:=$aMatlCost{$i}+$aMatlCostYD{$i}
					: ($aComKey{$i}="04@")
						$imatlFix:=$aMatlCost{$i}+$aMatlCostYD{$i}
					: ($aComKey{$i}="71@")
						$imatlFix:=$aMatlCost{$i}+$aMatlCostYD{$i}
					: ($aComKey{$i}="07-Embossing@")
						$imatlFix:=$aMatlCost{$i}+$aMatlCostYD{$i}
					Else 
						$imatlVar:=$aMatlCost{$i}
						$imatlYld:=$aMatlCostYD{$i}
				End case 
				//parse out the items and distribute costs
				$countitems:=0
				ARRAY TEXT:C222($aSplItems; $countitems)
				Repeat 
					$countitems:=$countitems+1
					ARRAY TEXT:C222($aSplItems; $countitems)
					$hit:=Position:C15(","; $aSplMatl{$i})
					If ($hit=0)
						$hit:=Length:C16($aSplMatl{$i})+1
					End if 
					$aSplItems{$countitems}:=Substring:C12($aSplMatl{$i}; 1; $hit-1)
					$aSplMatl{$i}:=Substring:C12($aSplMatl{$i}; $hit+1)
				Until (Length:C16($aSplMatl{$i})=0)
				$imatlFix:=$imatlFix/$countitems
				$imatlVar:=$imatlVar/$countitems
				$imatlYld:=$imatlYld/$countitems
				For ($j; 1; $countitems)
					$hit:=Find in array:C230($aItemNumber; $aSplItems{$j})
					If ($hit>-1)
						$aSplMatlFX{$hit}:=$aSplMatlFX{$hit}+$imatlFix
						$aSplMatlVR{$hit}:=$aSplMatlVR{$hit}+$imatlVar
						$aSplMatlYD{$hit}:=$aSplMatlYD{$hit}+$imatlYld
					End if 
					
				End for 
				ARRAY TEXT:C222($aSplItems; 0)
			End if   //spl alloc        
		End for 
		//*See if the plates, dupes, & dies are priced separtely
		//$breakouts:=[CaseScenario]Cost_Dups+[CaseScenario]Cost_Plates+
		//«[CaseScenario]Cost_Dies
		
		//*Overtime and Scrap Costs
		$laborVar:=$laborVar+[Estimates_Differentials:38]Cost_Overtime:17  //treat as variable
		$burdenVar:=$burdenVar+[Estimates_Differentials:38]Cost_Scrap:15  //treat as variable
		//*Calc the Fixed cost per Item on the job 
		$FCmatl:=$matlFix/$numberItems
		$FClabor:=$laborFix/$numberItems
		$FCburden:=$burdenFix/$numberItems
		
		//*Calc the Variable cost per sqin on the job
		$VCmatl:=$matlVar/($TotalSqIn/1000)
		$VClabor:=$laborVar/($TotalSqIn/1000)
		$VCburden:=$burdenVar/($TotalSqIn/1000)
		$VCmatlYD:=($matlVar+$matlYld)/($TotalSqInYD/1000)
		$VClaborYD:=($laborVar+$laborYld)/($TotalSqInYD/1000)
		$VCburdenYD:=($burdenVar+$burdenYld)/($TotalSqInYD/1000)
		
		//*Recontruct total costs
		$totalCost:=$matlFix+$laborFix+$burdenFix+$matlVar+$laborVar+$burdenVar
		$totalCostYD:=$totalCost+$matlYld+$laborYld+$burdenYld
		For ($i; 1; Size of array:C274($aItemNumber))
			$totalCost:=$totalCost+$aSplMatlFX{$i}+$aSplMatlVR{$i}+$aSplLaborFX{$i}+$aSplLaborVR{$i}+$aSplBurdFX{$i}+$aSplBurdVR{$i}
			$totalCostYD:=$totalCostYD+$aSplMatlFX{$i}+$aSplMatlVR{$i}+$aSplLaborFX{$i}+$aSplLaborVR{$i}+$aSplBurdFX{$i}+$aSplBurdVR{$i}+$aSplMatlYD{$i}+$aSplLaborYD{$i}+$aSplBurdYD{$i}
		End for 
		
		//*    Get Pricing Info
		QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=[Customers:16]ID:1; *)
		QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=[Estimates:17]Brand:3)
		If (Records in selection:C76([Customers_Brand_Lines:39])>0)
			$PV:=uNANCheck([Customers_Brand_Lines:39]ContractPV:7)
			REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)
		Else 
			$PV:=0
		End if 
		$rebate:=uNANCheck(fGetCustRebate([Customers:16]ID:1))  //•061998  MLB      
		
		//*    Calculate the price per sqin on the job
		If ($PV#0)
			//the intent here is to markup the price including the cost of the plates/dupes/
			//and dies, then, since they are billed separately, subtract their price=cost from
			//the total allocated price        
			$totWantPric:=fProfitVariable("Price"; $totalCost; 0; $PV; $rebate)  //•061998  MLB 
			$totWantPric:=$totWantPric-Round:C94($breakouts+$matlFix; 0)
			
			[Estimates_Differentials:38]OverallPrice:28:=$totWantPric
			
			$totYldPric:=fProfitVariable("Price"; $totalCostYD; 0; $PV; $rebate)  //•061998  MLB  
			$totYldPric:=$totYldPric-Round:C94($breakouts+$matlFix; 0)
			[Estimates_Differentials:38]OverallYldPrice:31:=$totYldPric
			
		Else 
			[Estimates_Differentials:38]OverallPrice:28:=0
			[Estimates_Differentials:38]OverallYldPrice:31:=0
		End if 
		
		[Estimates_Differentials:38]TotalPieces:8:=0
		[Estimates_Differentials:38]TotalPieceYld:10:=0
		//*STORE ANSWERS
		$recs:=Records in selection:C76([Estimates_Carton_Specs:19])
		FIRST RECORD:C50([Estimates_Carton_Specs:19])
		uThermoInit($recs; "Allocating Costs to Cartons")
		For ($i; 1; $recs)  //apply cost to item based on its sqin allocation on the job
			RELATE MANY:C262([Estimates_Carton_Specs:19]CartonSpecKey:7)  //get formcartons
			[Estimates_Carton_Specs:19]Quantity_Yield:29:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)  //0-determine Qty_yield for each carton_spec of form &
			
			If (Find in array:C230($aFormCarton; [Estimates_Carton_Specs:19]CartonSpecKey:7)>-1)  //`8/26/94 make sure not selling excess
				$cartonSqIn:=uNANCheck([Estimates_Carton_Specs:19]SquareInches:16)
				If ($cartonSqIn>0)
					If ([Estimates_Carton_Specs:19]Quantity_Want:27#0)  // `mod 9/22/94 deal with fill in cartons
						[Estimates_Carton_Specs:19]Quantity_Want:27:=Sum:C1([Estimates_FormCartons:48]FormWantQty:9)  //•052495 MLB UPR 1479
						[Estimates_Carton_Specs:19]Qty1Temp:52:=[Estimates_Carton_Specs:19]Quantity_Want:27  //•052495 MLB UPR 1479
						
						//*    Want Cost and Price
						[Estimates_Carton_Specs:19]CostLabor_Per_M:64:=($CartonSqIn*$VClabor)+($FClabor/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
						[Estimates_Carton_Specs:19]CostOH_Per_M:65:=($CartonSqIn*$VCburden)+($FCburden/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
						[Estimates_Carton_Specs:19]CostMatl_Per_M:66:=($CartonSqIn*$VCmatl)+($FCmatl/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
						[Estimates_Carton_Specs:19]CostScrap_Per_M:67:=0
						//*       Look for special allocations
						$hit:=Find in array:C230($aItemNumber; [Estimates_Carton_Specs:19]Item:1)
						If ($hit>0)
							[Estimates_Carton_Specs:19]CostLabor_Per_M:64:=[Estimates_Carton_Specs:19]CostLabor_Per_M:64+(($aSplLaborFX{$hit}+$aSplLaborVR{$hit})/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
							[Estimates_Carton_Specs:19]CostOH_Per_M:65:=[Estimates_Carton_Specs:19]CostOH_Per_M:65+(($aSplBurdFX{$hit}+$aSplBurdVR{$hit})/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
							[Estimates_Carton_Specs:19]CostMatl_Per_M:66:=[Estimates_Carton_Specs:19]CostMatl_Per_M:66+(($aSplMatlFX{$hit}+$aSplMatlVR{$hit})/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
						End if 
						[Estimates_Carton_Specs:19]CostWant_Per_M:25:=[Estimates_Carton_Specs:19]CostMatl_Per_M:66+[Estimates_Carton_Specs:19]CostLabor_Per_M:64+[Estimates_Carton_Specs:19]CostOH_Per_M:65
						//[CARTON_SPEC]CostSqInWant_M:=([CARTON_SPEC]CostWant_Per_M
						//«-$FClabor-$FCburden-$FCmatl)/$cartonSqIn
						[Estimates_Carton_Specs:19]z_CostSqInWant_M:31:=[Estimates_Carton_Specs:19]CostWant_Per_M:25/$cartonSqIn
						If ($PV#0)
							//[CARTON_SPEC]PriceWant_Per_M:=fProfitVariable ("Price";([CARTON_SPEC]CostWant_Pe
							[Estimates_Carton_Specs:19]PriceWant_Per_M:28:=([Estimates_Carton_Specs:19]CostWant_Per_M:25/$totalCost)*$totWantPric
						Else 
							[Estimates_Carton_Specs:19]PriceWant_Per_M:28:=0
						End if 
						
						//*    Yield Cost and Price
						[Estimates_Carton_Specs:19]CostYldLabor:68:=($CartonSqIn*$VClaborYD)+($FClabor/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
						[Estimates_Carton_Specs:19]CostYldOH:69:=($CartonSqIn*$VCburdenYD)+($FCburden/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
						[Estimates_Carton_Specs:19]CostYldMatl:70:=($CartonSqIn*$VCmatlYD)+($FCmatl/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
						[Estimates_Carton_Specs:19]CostYldSE:71:=0
						If ($hit>0)  //*       Look for special allocations
							[Estimates_Carton_Specs:19]CostYldLabor:68:=[Estimates_Carton_Specs:19]CostYldLabor:68+(($aSplLaborFX{$hit}+$aSplLaborVR{$hit}+$aSplLaborYD{$hit})/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
							[Estimates_Carton_Specs:19]CostYldOH:69:=[Estimates_Carton_Specs:19]CostYldOH:69+(($aSplBurdFX{$hit}+$aSplBurdVR{$hit}+$aSplBurdYD{$hit})/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
							[Estimates_Carton_Specs:19]CostYldMatl:70:=[Estimates_Carton_Specs:19]CostYldMatl:70+(($aSplMatlFX{$hit}+$aSplMatlVR{$hit}+$aSplMatlYD{$hit})/[Estimates_Carton_Specs:19]Quantity_Want:27*1000)
						End if 
						[Estimates_Carton_Specs:19]CostYield_Per_M:26:=[Estimates_Carton_Specs:19]CostYldMatl:70+[Estimates_Carton_Specs:19]CostYldLabor:68+[Estimates_Carton_Specs:19]CostYldOH:69
						//[CARTON_SPEC]CostSqInYield_M:=([CARTON_SPEC]CostYield_Per_M
						//«-$FClabor-$FCburden-$FCmatl)/$cartonSqIn
						[Estimates_Carton_Specs:19]z_CostSqInYield_M:32:=[Estimates_Carton_Specs:19]CostYield_Per_M:26/$cartonSqIn
						If ($PV#0)
							// [CARTON_SPEC]PriceYield_PerM:=fProfitVariable ("Price";[CARTON_SPEC]CostYield_P
							If ($totalCostYD>0)
								[Estimates_Carton_Specs:19]PriceYield_PerM:30:=([Estimates_Carton_Specs:19]CostYield_Per_M:26/$totalCostYD)*$totYldPric
							Else 
								[Estimates_Carton_Specs:19]PriceYield_PerM:30:=0
							End if 
						Else 
							[Estimates_Carton_Specs:19]PriceYield_PerM:30:=0
						End if 
						
					Else   //fill in
						[Estimates_Carton_Specs:19]z_CostSqInWant_M:31:=0
						[Estimates_Carton_Specs:19]CostLabor_Per_M:64:=0
						[Estimates_Carton_Specs:19]CostOH_Per_M:65:=0
						[Estimates_Carton_Specs:19]CostMatl_Per_M:66:=0
						[Estimates_Carton_Specs:19]CostScrap_Per_M:67:=0
						[Estimates_Carton_Specs:19]CostWant_Per_M:25:=0
						[Estimates_Carton_Specs:19]z_CostSqInYield_M:32:=0
						[Estimates_Carton_Specs:19]CostYldLabor:68:=0
						[Estimates_Carton_Specs:19]CostYldOH:69:=0
						[Estimates_Carton_Specs:19]CostYldMatl:70:=0
						[Estimates_Carton_Specs:19]CostYldSE:71:=0
						[Estimates_Carton_Specs:19]CostYield_Per_M:26:=0
						
					End if 
					
				Else   //excess sales
					[Estimates_Carton_Specs:19]z_CostSqInWant_M:31:=0
					[Estimates_Carton_Specs:19]CostLabor_Per_M:64:=0
					[Estimates_Carton_Specs:19]CostOH_Per_M:65:=0
					[Estimates_Carton_Specs:19]CostMatl_Per_M:66:=0
					[Estimates_Carton_Specs:19]CostScrap_Per_M:67:=0
					[Estimates_Carton_Specs:19]CostWant_Per_M:25:=0
					[Estimates_Carton_Specs:19]z_CostSqInYield_M:32:=0
					[Estimates_Carton_Specs:19]CostYldLabor:68:=0
					[Estimates_Carton_Specs:19]CostYldOH:69:=0
					[Estimates_Carton_Specs:19]CostYldMatl:70:=0
					[Estimates_Carton_Specs:19]CostYldSE:71:=0
					[Estimates_Carton_Specs:19]CostYield_Per_M:26:=0
				End if   //special costing
			End if   //$cartonSqIn>0
			
			//*Determine FG last price.
			QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Estimates_Carton_Specs:19]ProductCode:5; *)
			QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=[Estimates:17]Cust_ID:2)
			If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
				SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aXdate; [Finished_Goods_Transactions:33]PricePerM:19; $aXprice; [Finished_Goods_Transactions:33]ExtendedPrice:20; $aXextend)
				REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
				SORT ARRAY:C229($aXdate; $aXprice; $aXprice; <)
				[Estimates_Carton_Specs:19]PriceFGOH_M:23:=uNANCheck($aXprice{1})
				[Estimates_Carton_Specs:19]PriceFGOHin_M:24:=uNANCheck($aXextend{1})
			Else 
				[Estimates_Carton_Specs:19]PriceFGOH_M:23:=0
				[Estimates_Carton_Specs:19]PriceFGOHin_M:24:=0
			End if 
			
			SAVE RECORD:C53([Estimates_Carton_Specs:19])
			
			//*   Update the differentials total qty counts
			[Estimates_Differentials:38]TotalPieces:8:=[Estimates_Differentials:38]TotalPieces:8+[Estimates_Carton_Specs:19]Quantity_Want:27
			[Estimates_Differentials:38]TotalPieceYld:10:=[Estimates_Differentials:38]TotalPieceYld:10+[Estimates_Carton_Specs:19]Quantity_Yield:29
			
			NEXT RECORD:C51([Estimates_Carton_Specs:19])
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		SAVE RECORD:C53([Estimates_Differentials:38])
		
	Else 
		BEEP:C151
		ALERT:C41("No Square Inch totals found on the job, can't allocate variable costs.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("No Items found on the job, can't allocate fixed costs.")
End if 