//%attributes = {"publishedWeb":true}
//PM:  Est_CartonCostAllocationOld  091099  mlb
//formerly: sRunEstCartnCs3      mlb 8/22/94  
//chg algo and timing of sRunEstCartnCs2
//mod 8/26/94 only cost item if on a form.
//mod 8/30/94 assign yield quantity on carton spec
//mod 9/22/94 deal with fill in cartons
//mod 10/14/94 upr 1250 don't include fill-ins
//1/5/95
//3/30/95 add thermoset
//•052495 MLB UPR 1479 assert want qty based on form if not excess or fill-in
//•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
//•032697  MLB  calc base price based on PV
//•032797  MLB  declare yesterdays varibles
//•041797  mBohince  remove breakout costs
//•042397  MLB fix bug and change pricing algo 
//• 4/9/98 cs nan checking/removal
//• 4/13/98 cs Fixed problem with Yld pricing when Yld Lrgr than Want
//  appearent copy paste error using want calcs
//• 4/14/98 cs Nan checking
//•061998  MLB add rebate to pricing and PV calc

C_LONGINT:C283($i; $recs)
C_REAL:C285($PV; $totWantPric; $pricWSqin; $totYldPric; $pricYSqin; $breakouts; $rebate)  //•032797  MLB 

Est_LogIt("'Old Style' Carton Allocation")

//*get the total cost of the job
$otCost:=[Estimates_Differentials:38]Cost_Overtime:17
$laborCost:=[Estimates_Differentials:38]CostTtlLabor:11+$otCost  //•042397  MLB 
$burdonCost:=[Estimates_Differentials:38]CostTtlOH:12
$matlCost:=[Estimates_Differentials:38]CostTtlMatl:13
$scrapCost:=[Estimates_Differentials:38]Cost_Scrap:15
//*   see if the plates, dupes, & dies are priced separtely
$breakouts:=Round:C94(uNANCheck([Estimates_Differentials:38]Cost_Dups:19+[Estimates_Differentials:38]Cost_Plates:20+[Estimates_Differentials:38]Cost_Dies:21); 0)  //•041797  mBohince 
If ($Breakouts>0)  //• 4/23/97 cs insure that breakouts are not negative, from data entry, & not Nans
	$laborCost:=$laborCost-($breakouts*0.3)  //assume some distributions`•042397  MLB change / to *
	$burdonCost:=$burdonCost-($breakouts*0.1)
	$matlCost:=$matlCost-($breakouts*0.6)
Else 
	$breakouts:=0  //assertion  
End if 
$totalCost:=[Estimates_Differentials:38]CostTTL:14-$Breakouts  //•041797  mBohince  subtract out spls
If (Round:C94($totalCost; 2)#Round:C94(($laborCost+$burdonCost+$matlCost+$scrapCost); 2))
	$totalCost:=$laborCost+$burdonCost+$matlCost+$scrapCost
End if 

//*get yield additions
$yLaborCost:=0
$yBurdonCost:=0
QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_Differentials:38]Id:1+"@"; *)  //3-0144.00AA...
QUERY:C277([Estimates_Machines:20];  & ; [Estimates_Machines:20]Hrs_YldAddition:44#0)
ARRAY REAL:C219($aYldHrsAddition; 0)
ARRAY TEXT:C222($_CostCtrID; 0)  // Modified by: Mel Bohince (6/9/21) 
SELECTION TO ARRAY:C260([Estimates_Machines:20]Hrs_YldAddition:44; $aYldHrsAddition; [Estimates_Machines:20]CostCtrID:4; $_CostCtrID)
$recs:=Size of array:C274($aYldHrsAddition)
For ($i; 1; $recs)
	$yLaborCost:=uNANCheck($yLaborCost+($aYldHrsAddition{$i}*CostCtrCurrent("Labor"; $_CostCtrID{$i})))
	$yBurdonCost:=uNANCheck($yBurdonCost+($aYldHrsAddition{$i}*CostCtrCurrent("Burden"; $_CostCtrID{$i})))
End for 
ARRAY REAL:C219($aYldHrsAddition; 0)

$yMatlCost:=0
QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_Differentials:38]Id:1+"@"; *)  //3-0144.00AA...
QUERY:C277([Estimates_Materials:29];  & ; [Estimates_Materials:29]Matl_YieldAdds:26#0)
$yMatlCost:=Sum:C1([Estimates_Materials:29]Matl_YieldAdds:26)

//*get pricing components
QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=[Customers:16]ID:1; *)
QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=[Estimates:17]Brand:3)
If (Records in selection:C76([Customers_Brand_Lines:39])>0)
	$PV:=uNANCheck([Customers_Brand_Lines:39]ContractPV:7)
	REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)
Else 
	$PV:=0
End if 
$rebate:=uNANCheck(fGetCustRebate([Customers:16]ID:1))  //•061998  MLB  
//*    calculate the total price 
If ($PV#0)  //•032697  MLB  
	//the intent here is to markup the price including the cost of hte plates/dupes/
	//and dies, then, since they are billed separately, subtract their price=cost from
	//the total allocated price    
	$totWantPric:=fProfitVariable("Price"; ($totalCost+$breakouts); 0; $PV; $rebate)  //•061998  MLB 
	$totWantPric:=uNANCheck($totWantPric)  //-$breakouts)
	[Estimates_Differentials:38]OverallPrice:28:=$totWantPric
	
	$totYldPric:=fProfitVariable("Price"; ($totalCost+$yMatlCost+$yBurdonCost+$yLaborCost+$breakouts); 0; $PV; $rebate)  //•061998  MLB  
	$totYldPric:=uNANCheck($totYldPric)  //-Round($breakouts;0))
	[Estimates_Differentials:38]OverallYldPrice:31:=$totYldPric
	
Else 
	$totWantPric:=0
	$totYldPric:=0
	[Estimates_Differentials:38]OverallPrice:28:=0
	[Estimates_Differentials:38]OverallYldPrice:31:=0
End if 
SAVE RECORD:C53([Estimates_Differentials:38])
//utl_Trace 

//•091099  mlb  UPR 2052
$TotalSqIn:=Est_CalcAllocPercent([Estimates:17]EstimateNo:1; [Estimates_Differentials:38]diffNum:3)  //loads the Est_CollectionCartons
Est_LogIt(String:C10($TotalSqIn; "###,###,###,###")+" total square inches on the job")
$err:=Est_CollectionCartons("Store"; "Cost"; ""; $matlCost; ->[Estimates_Carton_Specs:19]CostMatl_Per_M:66)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; $laborCost; ->[Estimates_Carton_Specs:19]CostLabor_Per_M:64)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; $burdonCost; ->[Estimates_Carton_Specs:19]CostOH_Per_M:65)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; $scrapCost; ->[Estimates_Carton_Specs:19]CostScrap_Per_M:67)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; $totalCost; ->[Estimates_Carton_Specs:19]CostWant_Per_M:25)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; $totWantPric; ->[Estimates_Carton_Specs:19]PriceWant_Per_M:28)

$err:=Est_CollectionCartons("Store"; "Cost"; ""; ($matlCost+$yMatlCost); ->[Estimates_Carton_Specs:19]CostYldMatl:70)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; ($laborCost+$yLaborCost); ->[Estimates_Carton_Specs:19]CostYldLabor:68)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; ($burdonCost+$yBurdonCost); ->[Estimates_Carton_Specs:19]CostYldOH:69)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; $scrapCost; ->[Estimates_Carton_Specs:19]CostYldSE:71)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; ($totalCost+$yMatlCost+$yLaborCost+$yBurdonCost); ->[Estimates_Carton_Specs:19]CostYield_Per_M:26)
$err:=Est_CollectionCartons("Store"; "Cost"; ""; $totYldPric; ->[Estimates_Carton_Specs:19]PriceYield_PerM:30)

//Else 
//*get the total sqin of the job
//QUERY([FormCartons];[FormCartons]Form=[Differential]Id+"@")  `3
//«-0144.00AA...
//$recs:=Records in selection([FormCartons])  `3 - determine total sq
//« inches for form
//
//  `*    get a list of the cartons which should be costed, not sold
//« excesses
//ARRAY TEXT($aCartonKey;0)  `•120695  MLB  UPR 234 chg method of
//« primary keying CartonSpec records
//SELECTION TO ARRAY([FormCartons]Carton;$aCartonKey)  `8/26/94
//
//FIRST RECORD([FormCartons])
//$TotalSqIn:=0
//$TotalSqInYD:=0
//For ($i;1;$recs)  `calc total sqIn for the job
//RELATE ONE([FormCartons]Carton)  `get carton_spec
//$TotalSqInYD:=$TotalSqInYD+([CARTON_SPEC]SquareInches*[FormCartons
//«]MakesQty)
//If ([CARTON_SPEC]Quantity_Want>0)  `upr 1250 don't include fill-ins
//  `•091099  mlb  jobs don't do this     
//  `If ([FormCartons]FormWantQty=0)
//  `$TotalSqIn:=$TotalSqIn+([CARTON_SPEC]SquareInches*[CARTON_SPEC
//  `«]Quantity_Want)
//  `Else 
//$TotalSqIn:=$TotalSqIn+([CARTON_SPEC]SquareInches*[FormCartons
//«]FormWantQty)
//  `End if 
//End if 
//
//NEXT RECORD([FormCartons])
//End for 
//
//Est_LogIt (String($TotalSqIn;"###,###,###,###")+" total square inches on
//« the job")
//  `*calculate the cost per sqin on the job
//
//$FrmSqInCost:=uNANCheck ($totalCost/($TotalSqIn/1000))
//$LabSqin:=uNANCheck ($laborCost/($TotalSqIn/1000))
//$BurSqin:=uNANCheck ($burdonCost/($TotalSqIn/1000))
//$MatSqin:=uNANCheck ($matlCost/($TotalSqIn/1000))
//$SESqin:=uNANCheck ($scrapCost/($TotalSqIn/1000))
//
//$YldSqInCost:=uNANCheck (($totalCost+$yMatlCost+$yBurdonCost+$yLaborCost
//«)/($TotalSqInYD/1000))
//$yLabSqin:=uNANCheck (($laborCost+$yLaborCost)/($TotalSqInYD/1000))  `•
//« 4/13/98 cs 
//$yBurSqin:=uNANCheck (($burdonCost+$yBurdonCost)/($TotalSqInYD/1000))  
//«`• 4/13/98 cs 
//$yMatSqin:=uNANCheck (($matlCost+$yMatlCost)/($TotalSqInYD/1000))  `• 4
//«/13/98 cs 
//$ySESqin:=uNANCheck ($scrapCost/($TotalSqInYD/1000))  `• 4/13/98 cs 
//
//$pricWSqin:=uNANCheck ($totWantPric/($TotalSqIn/1000))
//$pricYSqin:=uNANCheck ($totYldPric/($TotalSqInYD/1000))  `• 4/13/98 cs 
//
//  `*multiply each cartons sqin by the cost per sqin to get carton cost
//« per 1000
//QUERY([CARTON_SPEC];[CARTON_SPEC]Estimate_No=[ESTIMATE]EstimateNo;*)  
//«`find Estimate Qty worksheet
//QUERY([CARTON_SPEC]; & ;[CARTON_SPEC]diffNum=[Differential]diffNum)
//$recs:=Records in selection([CARTON_SPEC])
//
//GOTO XY(1;2)
//MESSAGE(String(($recs);"^^^,^^^,^^^")+" more cartons to allocate")
//  `uThermoInit ($recs;"Allocating Costs to Cartons")
//For ($i;1;$recs)  `apply cost to item based on its sqin allocation on
//« the job
//
//RELATE MANY([CARTON_SPEC]CartonSpecKey)  `get formcartons
//[CARTON_SPEC]Quantity_Yield:=Sum([FormCartons]MakesQty)  `0-determine
//« Qty_yield for each carton_spec of form &
//
//If (Find in array($aCartonKey;[CARTON_SPEC]CartonSpecKey)>0)  ``8/26
//«/94 make sure not selling excess
//$cartonSqIn:=uNANCheck ([CARTON_SPEC]SquareInches)
//
//If ([CARTON_SPEC]Quantity_Want # 0)  ` `mod 9/22/94 deal with fill
//« in cartons
//
//[CARTON_SPEC]Quantity_Want:=Sum([FormCartons]FormWantQty)  
//«`•052495 MLB UPR 1479
//[CARTON_SPEC]Qty1Temp:=[CARTON_SPEC]Quantity_Want  `•052495 MLB
//« UPR 1479
//
//[CARTON_SPEC]CostSqInWant_M:=uNANCheck ($FrmSqInCost)
//
//[CARTON_SPEC]CostLabor_Per_M:=$CartonSqIn*$LabSqin
//[CARTON_SPEC]CostOH_Per_M:=$CartonSqIn*$BurSqin
//[CARTON_SPEC]CostMatl_Per_M:=$CartonSqIn*$MatSqin
//[CARTON_SPEC]CostScrap_Per_M:=$CartonSqIn*$SESqin
//[CARTON_SPEC]CostWant_Per_M:=$CartonSqIn*$FrmSqInCost
//
//[CARTON_SPEC]CostSqInYield_M:=uNANCheck ($YldSqInCost)
//
//[CARTON_SPEC]CostYldLabor:=uNANCheck ($CartonSqIn*$yLabSqin)
//[CARTON_SPEC]CostYldOH:=uNANCheck ($CartonSqIn*$yBurSqin)
//[CARTON_SPEC]CostYldMatl:=uNANCheck ($CartonSqIn*$yMatSqin)
//[CARTON_SPEC]CostYldSE:=uNANCheck ($CartonSqIn*$ySESqin)
//[CARTON_SPEC]CostYield_Per_M:=uNANCheck ($CartonSqIn*$YldSqInCost)
//
//[CARTON_SPEC]PriceWant_Per_M:=uNANCheck ($CartonSqIn*$pricWSqin)  
//«`•032697  MLB 
//[CARTON_SPEC]PriceYield_PerM:=uNANCheck ($CartonSqIn*$pricYSqin)  
//«`•032697  MLB 
//
//Else   `fill in
//[CARTON_SPEC]CostSqInWant_M:=0
//
//[CARTON_SPEC]CostLabor_Per_M:=0
//[CARTON_SPEC]CostOH_Per_M:=0
//[CARTON_SPEC]CostMatl_Per_M:=0
//[CARTON_SPEC]CostScrap_Per_M:=0
//[CARTON_SPEC]CostWant_Per_M:=0
//
//[CARTON_SPEC]CostSqInYield_M:=0
//
//[CARTON_SPEC]CostYldLabor:=0
//[CARTON_SPEC]CostYldOH:=0
//[CARTON_SPEC]CostYldMatl:=0
//[CARTON_SPEC]CostYldSE:=0
//[CARTON_SPEC]CostYield_Per_M:=0
//
//End if 
//
//Else   `excess sales
//[CARTON_SPEC]CostSqInWant_M:=0
//
//[CARTON_SPEC]CostLabor_Per_M:=0
//[CARTON_SPEC]CostOH_Per_M:=0
//[CARTON_SPEC]CostMatl_Per_M:=0
//[CARTON_SPEC]CostScrap_Per_M:=0
//[CARTON_SPEC]CostWant_Per_M:=0
//
//[CARTON_SPEC]CostSqInYield_M:=0
//
//[CARTON_SPEC]CostYldLabor:=0
//[CARTON_SPEC]CostYldOH:=0
//[CARTON_SPEC]CostYldMatl:=0
//[CARTON_SPEC]CostYldSE:=0
//[CARTON_SPEC]CostYield_Per_M:=0
//End if   `special costing
//
//
//  `*determine FG last price.
//QUERY([FG_Transactions];[FG_Transactions]ProductCode=[CARTON_SPEC
//«]ProductCode;*)
//QUERY([FG_Transactions]; & ;[FG_Transactions]CustID=[ESTIMATE]Cust_ID;
//«*)
//QUERY([FG_Transactions]; & ;[FG_Transactions]XactionType="Ship")  `•9
//«/14/99  MLB 
//ORDER BY([FG_Transactions];[FG_Transactions]XactionDate;<)
//  `FIRST RECORD([FG_Transactions])
//[CARTON_SPEC]PriceFGOH_M:=uNANCheck ([FG_Transactions]PricePerM)
//  `[CARTON_SPEC]PriceFGOHin_M:=uNANCheck ([FG_Transactions
//«]ExtendedPrice)
//
//SAVE RECORD([CARTON_SPEC])
//NEXT RECORD([CARTON_SPEC])
//  `uThermoUpdate ($i;1)
//GOTO XY(1;2)
//MESSAGE(String(($recs-$i);"^^^,^^^,^^^")+" more cartons to allocate")
//End for 
//GOTO XY(1;2)
//MESSAGE("           "+"                                                 
//«    ")
//uThermoClose 