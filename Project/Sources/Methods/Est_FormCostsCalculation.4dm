//%attributes = {"publishedWeb":true}
//PM:  Est_FormCostsCalculation  091099  mlb
//called by Est_Calculate`
//formerly sRunEstimate()   -created MLB         -7/93
//                          -modified by JML   -8/3/93
//                          -modified by MLB   -11/10/93
//                          -modified by MLB   -12/14/93 add HP kludge
//                          -modified by MLB   -1/21/94 upr 33
//                          -modified by MLB   -2/10/94 upr 1001,1007,1021
//                          -modified by MLB   -3/1/94 cancel if no sqin's
//                          -modified by MLB   -3/24/94 upr 1045
//                          -modified by MLB   -5/23/94 upr 60
//                           11/23/94 search selection for machine_est when lookin
//                           UPR 1148 chip 02/10/95
//                          -modified by MLB   -3/15/95 upr 66
//                          -upr 1463 3/29/95
//                         `4/5/95 read only the c/c file
//                         5/8/95 marker comments added
//•                        051096 UPR  add M.A.N. Roland  700 
// •       mel (1/20/05, 14:51:25) add the 413
//•060696  MLB  add stamp and gluer choices   
//•071296  MLB set the std labor & burden in the machest record  
//•071896 MLB  Mark Andy 
//•090696  MLB 476 477    
//• 5/23/97 cs upr 1870 - consistant use of width/length values, with JobBag
//• 3/25/98 cs  Requested by Mel  
//090198 mlb allow test rates
//•091099  mlb  erronously compared [JobForm] fields!
//•121099  mlb  be more picky about complex glueing cross check
//called from sRunEstAll, which is attsched to Calculate button in
//the [estimate];"Input" page 3
//•4/20/00  mlb  add 428
//•9/11/00  mlb  add 888 for intercompany tranxit
// • mel (6/9/05, 09:23:42) use BenMarkens rate/inch formula in test mode


//The [caseform] input layout can be accessed directly or from the Estimate input
//layout.  When accessed directly, there is possibility that it will not be able t
//update totals in the Differential or Carton_spec records ( do to locked records.
//The 'Update Differential' button, found in the Estimate input layout, takes care
//of this problem.  In addition to building and reconciling differential records, 
//also will toal up costs for differentials and carton specs of the estimate.

// Modified by: Mel Bohince (1/13/14) made sure 418 is calc'd, better use of ip vars from uInitInterPrsVar
// Modified by: Mel Bohince (1/21/16) sub stamper 452 for embosserer 552 which was a phamtom
// Modified by: Mel Bohince (10/5/16) change method to determine if sheeter will slit
// Modified by: Mel Bohince (8/4/17) added 472 windower
// Modified by: Mel Bohince (3/26/19) update the strait line designation
// Modified by: Mel Bohince (6/9/21) Use Storage

C_LONGINT:C283($i; $k; $numSeq; $lastGross; $numMatl; $NumberUp; $matlError; $grossWin; $netCartons; $YldCartons; $grossCoat; $lastCartons)
C_LONGINT:C283(iTemporyNetQty; sheetsPerCut)  //always equal to fLastGross, used in fCalcDimCheck()
C_LONGINT:C283(PlannedNet; $TTLyldWaste; yldWaste; $wantWaste; $yldWin)  //to make calcs like the HP, and to tally waste at yield qty's
C_BOOLEAN:C305(<>fContinue; $isCoating; $isShort; $isFoil; $isAirKnife; $isFilmLam; $isfitted; $nonRegister; $Imaje; $StrateLine; $CartonStrip; $isInline; $isDieCut; $Inspection)
C_REAL:C285(formWidth; formLength; $FilmLamGaug; $caliper)
C_TEXT:C284($FilmLamType)
C_TEXT:C284($CC)  //•060696  MLB  lower disk hits, nitpicken
C_TEXT:C284($t; $cr)
ARRAY TEXT:C222(sDieCutOpt; 0)
ARRAY LONGINT:C221(iNumUp; 0)

MESSAGES OFF:C175

//vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
//AMS was designed to calculate waste at each cc based on the # sheets to run at 
//that cc. The HP used the same net sheets at each cc. Arkay has instructed
//ISI to revise the calculations to match the HP algorithm in stead of 
//correcting the operation standards. Therefore; beware, DO NOT DEPEND
//ON THESE NUMBERS FOR EXPLODING MATERIAL REQUIREMENTS.
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

$t:=Char:C90(9)
$cr:=Char:C90(13)
Est_FormCostsinit
Est_LogIt("Calculating "+[Estimates_DifferentialsForms:47]DiffFormId:3+" with:")
PlannedNet:=[Estimates_DifferentialsForms:47]NumberSheets:4
$isShort:=Est_FormOrientation([Estimates_DifferentialsForms:47]ShortGrain:11; ->formWidth; ->formLength)
sheetsPerCut:=1  // Modified by: Mel Bohince (10/5/16) //this can be changed by the sheeter calc

//*get everything from p-spec
If ([Estimates:17]Cust_ID:2#<>sCombindID)
	If ([Estimates_DifferentialsForms:47]ProcessSpec:23#"")  //try at the form level first
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_DifferentialsForms:47]ProcessSpec:23; *)
		QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Estimates:17]Cust_ID:2)  //get process spec
	Else 
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_Differentials:38]ProcessSpec:5; *)
		QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Estimates:17]Cust_ID:2)  //get process spec
	End if 
Else 
	If ([Estimates_DifferentialsForms:47]ProcessSpec:23#"")  //try at the form level first
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_DifferentialsForms:47]ProcessSpec:23)
	Else 
		QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_Differentials:38]ProcessSpec:5)
	End if 
End if 

If (Records in selection:C76([Process_Specs:18])>0)
	$caliper:=Round:C94([Process_Specs:18]Caliper:8; 4)  //426,490,496 `these dimensions are also passed to material calcs
	If (([Process_Specs:18]Coat1Type:13="") & ([Process_Specs:18]Coat2Type:15="") & ([Process_Specs:18]Coat3Type:17="") & ([Process_Specs:18]iCoat1Type:19="") & ([Process_Specs:18]iCoat2Type:21="") & ([Process_Specs:18]iCoat3Type:23=""))
		$isCoating:=False:C215
	Else 
		$isCoating:=True:C214  //426
	End if 
	$isFoil:=([Process_Specs:18]FoilType:9#"")  //427
	$isAirKnife:=([Process_Specs:18]iAKcover:36 | [Process_Specs:18]AKcover:39)  //427
	$FilmLamGaug:=[Process_Specs:18]FilmLamGauge:12
	$FilmLamType:=[Process_Specs:18]FilmLaminate:11
	$isFilmLam:=[Process_Specs:18]FilmLaminate:11#""  //451
	$numGrav:=[Process_Specs:18]ColorsNumGravur:25+[Process_Specs:18]iColorGrav:55  //427
	//463 v
	$isfitted:=(([Process_Specs:18]EmbossFitted:79 & [Process_Specs:18]EmbossOverall:80) | ([Process_Specs:18]Emboss2Fitted:91 & [Process_Specs:18]Emboss2Overall:92))
	$nonRegister:=[Process_Specs:18]z_EmbossNonRegis:83 | [Process_Specs:18]z_Emboss2NonRegis:95
	//461 465
	$isInline:=[Process_Specs:18]z_EmbossInLineApv:82 | [Process_Specs:18]z_Emboss2InlineAp:94
	$isDieCut:=[Process_Specs:18]DieCut:51
	
	Est_LogIt("Stock Caliper = "+String:C10($caliper))
	Est_LogIt("Coating = "+("Yes"*Num:C11($isCoating))+("No"*Num:C11(Not:C34($isCoating))))
	Est_LogIt("Foil = "+("Yes"*Num:C11($isFoil))+("No"*Num:C11(Not:C34($isFoil))))
	Est_LogIt("Air Knife = "+("Yes"*Num:C11($isAirKnife))+("No"*Num:C11(Not:C34($isAirKnife))))
	Est_LogIt("Film Lam. = "+("Yes"*Num:C11($isFilmLam))+("No"*Num:C11(Not:C34($isFilmLam)))+String:C10($FilmLamGaug; " 0.00000 ")+$FilmLamType)
	Est_LogIt("#Gravure Colors = "+String:C10($numGrav))
	Est_LogIt("Nonregister = "+("Yes"*Num:C11($nonRegister))+("No"*Num:C11(Not:C34($nonRegister))))
	Est_LogIt("Inline Emboss Appv = "+("Yes"*Num:C11($isInline))+("No"*Num:C11(Not:C34($isInline))))
	Est_LogIt("Die Cut = "+("Yes"*Num:C11($isDieCut))+("No"*Num:C11(Not:C34($isDieCut))))
	
Else 
	BEEP:C151
	BEEP:C151
	Est_LogIt("Calculation failed.  The process specification does not exist for this customer.")
	ALERT:C41("Calculation failed.  The process specification does not exist for this customer.")
	<>fContinue:=False:C215
End if 

If (<>fContinue)  //*get everything from the FormCartons and C-Spec
	RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)  //get [formcartons], mach & matls
	ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3; >)
	<>fContinue:=Est_SubformBreakDown
	$NumberUp:=0  //415,490,583,585,491,501,502
	$netCartons:=0  //comm 51
	$YldCartons:=0
	$Imaje:=False:C215
	$StrateLine:=True:C214
	$CartonStrip:=False:C215
	$Inspection:=False:C215
	If (bAddPlate=1)
		CostCtr_addBasedOnRule("403")
	End if 
	
	$k:=Records in selection:C76([Estimates_FormCartons:48])
	$Item:=$k
	ARRAY TEXT:C222(sDieCutOpt; $k)
	ARRAY LONGINT:C221(iNumUp; $k)
	// • mel (6/10/05, 09:23:42) use BenMarkens rate/inch formula in test mode
	ARRAY LONGINT:C221(aCartonsPerHr; $k)
	ARRAY LONGINT:C221($aItemQty; $k)
	ARRAY REAL:C219(aCartonProportion; $k)
	
	FIRST RECORD:C50([Estimates_FormCartons:48])
	$numSubForms:=0
	
	//$glueTime:=0  ` • mel (6/9/05, 09:23:42) use BenMarkens rate/inch formula in test mode
	//$glueInches:=0  `per item
	//gluerHrs:=0  `accumulate for all items
	//gluerRate:=0  `mean rate
	$glueLengthConstant:=1
	$straightLineRate:=270000
	$complexRate:=150000
	$tuck:=2*0.75  //blank length = H + 2B + 2t , using W as B
	$blankLength:=0
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		For ($j; 1; $k)  //*.  look for striping unit
			If ([Estimates_FormCartons:48]SubFormNumber:10>$numSubForms)
				$numSubForms:=[Estimates_FormCartons:48]SubFormNumber:10
			End if 
			$NumberUp:=$NumberUp+[Estimates_FormCartons:48]NumberUp:4
			$YldCartons:=$YldCartons+[Estimates_FormCartons:48]MakesQty:5
			If ([Estimates_FormCartons:48]NumberUp:4#0)  //*.   make sure it is actually on the form
				iNumUp{$j}:=[Estimates_FormCartons:48]NumberUp:4
				RELATE ONE:C42([Estimates_FormCartons:48]Carton:1)
				
				If ([Estimates_FormCartons:48]FormWantQty:9>0)
					$netCartons:=$netCartons+[Estimates_FormCartons:48]FormWantQty:9
				Else 
					$netCartons:=$netCartons+[Estimates_Carton_Specs:19]Quantity_Want:27
				End if 
				//*.  need some other stuff while were at the c-spec.
				sDieCutOpt{$j}:=[Estimates_Carton_Specs:19]DieCutOptions:49
				If ([Estimates_Carton_Specs:19]SecurityLabels:43)
					$Imaje:=True:C214
				End if 
				
				$aItemQty{$j}:=[Estimates_FormCartons:48]MakesQty:5
				$h:=[Estimates_Carton_Specs:19]Height_Dec:22
				If ($h=0)
					$h:=Num:C11(util_fractionToDecimal([Estimates_Carton_Specs:19]Height:19))
				End if 
				$w:=[Estimates_Carton_Specs:19]Width_Dec:20
				If ($w=0)
					$w:=Num:C11(util_fractionToDecimal([Estimates_Carton_Specs:19]Width:17))
				End if 
				$blankLength:=$h+(2*$w)+$tuck
				If ($blankLength<=$tuck)
					//BEEP
					Est_LogIt([Estimates_Carton_Specs:19]ProductCode:5+" does not have glue length specified.")
					//CONFIRM([CARTON_SPEC]ProductCode+" does not have glue length specified.";"Continue";"Abort")
					//If (ok=0)
					//◊fContinue:=False
					//End if 
					//estCalcError:=True
				End if 
				aCartonsPerHr{$j}:=Trunc:C95($straightLineRate/($blankLength+$glueLengthConstant); -2)
				//$glueInches:=[FormCartons]MakesQty*($blankLength+$glueLengthConstant)
				//$glueTime:=$glueInches/$straightLineRate  ` • mel (6/9/05, 09:23:42) use BenMarkens rate/inch formula in test mode
				If ([Estimates_Carton_Specs:19]GlueType:41#"straight line")
					If ([Estimates_Carton_Specs:19]GlueType:41#"")  //•121099  mlb  
						If ([Estimates_Carton_Specs:19]GlueType:41#"none")  //•121099  mlb 
							$StrateLine:=False:C215
							aCartonsPerHr{$j}:=Trunc:C95($complexRate/($blankLength+$glueLengthConstant); -2)
							//$glueTime:=$glueInches/$complexRate  ` • mel (6/9/05, 09:23:42) use BenMarkens rate/inch formula in test mode
						End if 
					End if 
				End if 
				//gluerHrs:=gluerHrs+$glueTime  ` • mel (6/9/05, 09:23:42) use BenMarkens rate/inch formula in test mode
				
				If ([Estimates_Carton_Specs:19]StripHoles:46)
					$CartonStrip:=True:C214
				End if 
				
				If ([Estimates_Carton_Specs:19]GlueInspect:42)
					$Inspection:=True:C214
				End if 
				If ([Estimates_Carton_Specs:19]SquareInches:16=0)
					BEEP:C151
					Est_LogIt([Estimates_Carton_Specs:19]ProductCode:5+" does not have square inches specified.")
					CONFIRM:C162([Estimates_Carton_Specs:19]ProductCode:5+" does not have square inches specified."; "Continue"; "Abort")
					If (OK=0)
						<>fContinue:=False:C215
					End if 
					estCalcError:=True:C214
				End if 
			End if   //on the form      
			NEXT RECORD:C51([Estimates_FormCartons:48])
		End for 
		
	Else 
		
		ARRAY LONGINT:C221($_FormWantQty; 0)
		ARRAY LONGINT:C221($_SubFormNumber; 0)
		ARRAY LONGINT:C221($_NumberUp; 0)
		ARRAY TEXT:C222($_Carton; 0)
		ARRAY LONGINT:C221($_FormWantQty; 0)
		ARRAY LONGINT:C221($_MakesQty; 0)
		
		
		SELECTION TO ARRAY:C260([Estimates_FormCartons:48]FormWantQty:9; $_FormWantQty; \
			[Estimates_FormCartons:48]SubFormNumber:10; $_SubFormNumber; \
			[Estimates_FormCartons:48]NumberUp:4; $_NumberUp; \
			[Estimates_FormCartons:48]Carton:1; $_Carton; \
			[Estimates_FormCartons:48]FormWantQty:9; $_FormWantQty; \
			[Estimates_FormCartons:48]MakesQty:5; $_MakesQty)
		
		For ($j; 1; $k; 1)  //*.  look for striping unit
			If ($_SubFormNumber{$j}>$numSubForms)
				$numSubForms:=$_SubFormNumber{$j}
			End if 
			$NumberUp:=$NumberUp+$_NumberUp{$j}
			$YldCartons:=$YldCartons+$_MakesQty{$j}
			If ($_NumberUp{$j}#0)  //*.   make sure it is actually on the form
				iNumUp{$j}:=$_NumberUp{$j}
				QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]CartonSpecKey:7=$_Carton{$j})
				
				If ($_FormWantQty{$j}>0)
					$netCartons:=$netCartons+$_FormWantQty{$j}
				Else 
					$netCartons:=$netCartons+[Estimates_Carton_Specs:19]Quantity_Want:27
				End if 
				
				sDieCutOpt{$j}:=[Estimates_Carton_Specs:19]DieCutOptions:49
				If ([Estimates_Carton_Specs:19]SecurityLabels:43)
					$Imaje:=True:C214
				End if 
				
				$aItemQty{$j}:=$_MakesQty{$j}
				$h:=[Estimates_Carton_Specs:19]Height_Dec:22
				If ($h=0)
					$h:=Num:C11(util_fractionToDecimal([Estimates_Carton_Specs:19]Height:19))
				End if 
				$w:=[Estimates_Carton_Specs:19]Width_Dec:20
				If ($w=0)
					$w:=Num:C11(util_fractionToDecimal([Estimates_Carton_Specs:19]Width:17))
				End if 
				$blankLength:=$h+(2*$w)+$tuck
				If ($blankLength<=$tuck)
					Est_LogIt([Estimates_Carton_Specs:19]ProductCode:5+" does not have glue length specified.")
				End if 
				aCartonsPerHr{$j}:=Trunc:C95($straightLineRate/($blankLength+$glueLengthConstant); -2)
				// Modified by: Mel Bohince (3/26/19) update the strait line designation
				If (Position:C15("straight line"; [Estimates_Carton_Specs:19]GlueType:41)=0)  //([Estimates_Carton_Specs]GlueType#"straight line")
					If ([Estimates_Carton_Specs:19]GlueType:41#"")  //•121099  mlb  
						If ([Estimates_Carton_Specs:19]GlueType:41#"none")  //•121099  mlb 
							$StrateLine:=False:C215
							aCartonsPerHr{$j}:=Trunc:C95($complexRate/($blankLength+$glueLengthConstant); -2)
						End if 
					End if 
				End if 
				
				If ([Estimates_Carton_Specs:19]StripHoles:46)
					$CartonStrip:=True:C214
				End if 
				
				If ([Estimates_Carton_Specs:19]GlueInspect:42)
					$Inspection:=True:C214
				End if 
				If ([Estimates_Carton_Specs:19]SquareInches:16=0)
					BEEP:C151
					Est_LogIt([Estimates_Carton_Specs:19]ProductCode:5+" does not have square inches specified.")
					CONFIRM:C162([Estimates_Carton_Specs:19]ProductCode:5+" does not have square inches specified."; "Continue"; "Abort")
					If (OK=0)
						<>fContinue:=False:C215
					End if 
					estCalcError:=True:C214
				End if 
			End if   //on the form      
			
		End for 
		
	End if   // END 4D Professional Services : January 2019 
	
	[Estimates_DifferentialsForms:47]Subforms:31:=$numSubForms
	
	//gluerHrs:=Round(gluerHrs;2)
	//gluerRate:=Round(($YldCartons/gluerHrs);0)  ` • mel (6/9/05, 09:23:42) use BenMarkens rate/inch formula in test mode
	For ($j; 1; $k)
		aCartonProportion{$j}:=$aItemQty{$j}/$YldCartons
	End for 
	ARRAY LONGINT:C221($aItemQty; 0)
	
	
	If ([Estimates_DifferentialsForms:47]NumberUpOverrid:30#0)  //upr 60
		$NumberUp:=[Estimates_DifferentialsForms:47]NumberUpOverrid:30
		Est_LogIt("WARING WARNING WARNING: Number Up Override engaged and set to "+String:C10($NumberUp))
	End if 
	
	//*Display the specs found
	Est_LogIt("Number Items = "+String:C10($Item))  //$Item
	Est_LogIt("Number up = "+String:C10($NumberUp))  //
	Est_LogIt("Net Cartons = "+String:C10($netCartons))
	Est_LogIt("Yield Cartons = "+String:C10($YldCartons))
	Est_LogIt("Excess Cartons = "+String:C10(((($YldCartons-$netCartons)/$netCartons)*100); "###0.0%"))
	Est_LogIt("Imaje = "+("Yes"*Num:C11($Imaje))+("No"*Num:C11(Not:C34($Imaje))))
	Est_LogIt("Inspection = "+("Yes"*Num:C11($Inspection))+("No"*Num:C11(Not:C34($Inspection))))
	Est_LogIt("Straight Line = "+("Yes"*Num:C11($StrateLine))+("No"*Num:C11(Not:C34($StrateLine))))
	Est_LogIt("Strip Carton Holes = "+("Yes"*Num:C11($CartonStrip))+("No"*Num:C11(Not:C34($CartonStrip))))
	Est_LogIt("Die Cut Options:   ")
	For ($j; 1; Size of array:C274(sDieCutOpt))
		Est_LogIt(sDieCutOpt{$j}+" "+String:C10(iNumUp{$j})+" up  ")
	End for 
	
End if   //form/carton specs continue

//*Do some cross checks on the specs and the machine details
//If (<>fContinue) // Modified by: Mel Bohince (8/1/16) run cross check even it errors
<>fContinue:=Est_CrossChecks($Imaje; $Inspection; $StrateLine; $numSubForms)
//End if 

If (<>fContinue)
	$numSeq:=Records in selection:C76([Estimates_Machines:20])
Else 
	$numSeq:=0
End if 
//*Calc each CC on  the machine est
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; <)
	FIRST RECORD:C50([Estimates_Machines:20])  //start at the glue line (last operation)
	
	
Else 
	
	ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; <)
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
$lastCartons:=$YldCartons  //stripping/blk'g sheets required = carton yield + carton waste/#up
$grossWin:=0  //case there is no windowing
$yldWin:=0
$lastGross:=[Estimates_DifferentialsForms:47]NumberSheets:4  // should be correctl set by lastCarton/#up.
TTLyldWaste:=0
yldWaste:=0
$wantWaste:=0

For ($i; 1; $numSeq)
	If (Not:C34(<>fContinue))
		$i:=$NumSeq+1  //terminate loop
		
	Else 
		Est_MachineInit("qty")  //*.   Init the calc'd fields  
		Est_MachineInit("cost")
		Est_MachineInit("hrs")
		
		If (Position:C15([Estimates_Machines:20]CostCtrID:4; <>EMBOSSERS)>0)  // Modified by: Mel Bohince (1/21/16) 
			[Estimates_Machines:20]CostCtrID:4:="4"+Substring:C12([Estimates_Machines:20]CostCtrID:4; 2)
		End if 
		$CC:=[Estimates_Machines:20]CostCtrID:4
		
		iTemporyNetQty:=$LastGross  //used in fCalcDimCheck(), a hack(alternative to passing as a argument) to fix a b
		//*.   Get the CC standards   
		If (bTestRates=0)  //090198
			$numCC:=qryCostCenter($CC; [Estimates_Machines:20]UseStdDated:43)  //3/15/95 upr 66
		Else 
			$numCC:=qryCostCenter($CC; !1991-09-01!)  //`090198
		End if 
		<>fContinue:=($numCC>0)
		C_TEXT:C284($description)  // Modified by: Mel Bohince (6/9/21) Use Storage
		$description:=""
		C_DATE:C307($effective)
		$effective:=!00-00-00!
		$cc_found:=CostCtrCurrent("dated"; $CC; ->$effective)
		$cc_found:=CostCtrCurrent("Desc"; $CC; ->$description)
		Est_LogIt($CC+"   "+$description+" effective "+String:C10($effective; Internal date short special:K1:4))
		[Estimates_Machines:20]LaborStd:7:=CostCtrCurrent("Labor"; $CC)  //[COST_CENTER]MHRlaborSales  `•090799  mlb  UPR 2052
		[Estimates_Machines:20]OverheadStd:8:=CostCtrCurrent("Burden"; $CC)  //[COST_CENTER]MHRburdenSales  `•090799  mlb  UPR 2052
		[Estimates_Machines:20]OOPStd:17:=[Estimates_Machines:20]LaborStd:7+[Estimates_Machines:20]OverheadStd:8  //•071296  MLB  
		[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13  //CostCtrCurrent ("Date";$CC)
		//in the following fCalcXxxx procs, the following 2 lines of code were added
		//-->$net:=PlannedNet  ` to match HP kluge style waste calculation
		//-->$net:=$1  ` to recover from HP kluge style waste calculation
		// and the first occurance of --> $net:=$1 was commented out
		// so that waste is calc'd based on static net sheets, not compounding gross
		
		//w.r.t. cartons: the qty's for yield and want should be specified at the form
		//op level, if not the total want qty will be used. Note: their fCalcsXxxx return 
		//waste, not gross
		
		//The stripping or blanking operation now always yields enough sheets 
		//that the yield qty of cartons could be glued if desired. This done  by changing
		//the algorythym for carton unit operations
		
		//*.   Dispatch to each CC    
		utl_Trace
		
		Case of   //see (P) beforeMachineEs for flex field definisitons
			: (Not:C34(Est_FormDimensionCheck))
				$i:=$NumSeq+1  //◊fContinue is now false, so abort
				
			: ($CC="401") | ($CC="402") | ($CC="403")  //• 3/25/98 cs  Requested by Mel
				$lastGross:=fCalcPlate($lastGross; $NumberUp; $Item)  // 
				
			: ($CC="405")  //imaging upr 1193
				$lastGross:=fCalcImaging($lastGross)
				
				//: ($CC="411")  `•071896 MLB  Mark Andy        
				//$lastGross:=fCalcMarkAndy ($lastGross;[PROCESS_SPEC]Stock
				//«;$NumberUp;$YldCartons;formLength)
				
			: (($CC="414") | ($CC="415"))  //also in <>PRESSES below
				If (<>SubformCalc)  //3/20/95 upr 66
					$lastGross:=fCalcPress_Sub($lastGross; $NumberUp; $caliper)  //. 
				Else 
					$lastGross:=fCalcPress($lastGross; $NumberUp; $caliper)  //. 
				End if 
				
			: (Position:C15($CC; <>PRESSES)>0)  //($CC="412") | ($CC="416") | ($CC="413"))  //•051096 MLB  M.A.N. Roland  700 `•072102  mlb  416     
				// • mel (1/20/05, 14:51:25) add the 413
				// Modified by: Mel Bohince (10/3/17) make reductions for plastic
				CUT NAMED SELECTION:C334([Estimates_Materials:29]; "holdMatl")
				C_LONGINT:C283($plastic)
				$plastic:=0  //0 if not found
				$diffFormId:=[Estimates_DifferentialsForms:47]DiffFormId:3
				Begin SQL
					select count(*) from Estimates_Materials where DiffFormID = :$diffFormId and (Commodity_Key like '20-%' or Raw_Matl_Code like '%APET%') into :$plastic
				End SQL
				USE NAMED SELECTION:C332("holdMatl")
				
				$lastGross:=fCalcRoland700($lastGross; $NumberUp; $plastic)  //. 
				
				//: ($CC="417")obsolete screen press
				//$lastGross:=fCalcPress2 ($lastGross)  //         
				
				//: ($CC="419")
				//$LastGross:=fCalcPress3 ($LastGross)  //.  not available        
				
			: (Position:C15($CC; <>SHEETERS)>0)  //$CC="426") | ($CC="428")  //•4/20/00  mlb  add 428
				$lastGross:=fCalcSheeter($lastGross; $isFoil; $caliper; formWidth; formLength; ->sheetsPerCut)  // Modified by: Mel Bohince (10/5/16) added rtn of sheets per cut//. 
				
			: ($CC="427")
				$lastGross:=fCalcGravure($lastGross; $isFoil; formWidth; formLength; $isAirKnife; $numGrav)  //.
				
			: ($CC="431")
				$LastGross:=fCalcInkMake($LastGross)
				
			: ($CC="442") | ($CC="443")  //• 3/25/98 cs  request by Mel (443)
				$lastGross:=fCalcDieMake($lastGross; $CartonStrip)  //use 2 arrays defined in carton section            
				//see CostCtr_FlexFieldLabels
			: (Position:C15($CC; <>STAMPERS)#0)  //•4/14/00  mlb  add roanoke stamping
				$lastGross:=fCalcStamping($LastGross; $isFilmLam)  //.
				
			: (Position:C15($CC; <>EMBOSSERS)#0)  //ask Dan Mayrosh
				$lastGross:=fCalcBobst($lastGross; $CartonStrip; $isFilmLam; $isInline; $isDieCut)
				
				//: ($CC="455")
				//$lastGross:=fCalcStamping2 ($LastGross;$isFilmLam;$NumberUp)  `
				
			: (Position:C15($CC; <>BLANKERS)#0)  //•060696  MLB  add 462 & 468
				$lastGross:=fCalcBobst($lastGross; $CartonStrip; $isFilmLam; $isInline; $isDieCut)
				
				
				
			: ($CC="463") | ($CC="563")  // Modified by: Mel Bohince (1/21/16) obsolete?
				$LastGross:=fCalcBobEmboss($LastGross; $isfitted; $isFilmLam; $nonRegister; $isInline; $isDieCut)  //`ask Dan Mayrosh        
				
				//: ($CC="466")
				//$LastGross:=fCalc466TurnTable ($LastGross)
				
			: (Position:C15($CC; <>COATERS)#0)  //($CC="471") )
				$lastGross:=fCalcCoater($LastGross)
				$grossCoat:=$lastGross
				
			: (Position:C15($CC; <>LAMINATERS)>0)  //($CC="473") | ($CC="474") | ($CC="475"))
				$lastGross:=fCalcLaminator($LastGross)
				
				
			: ($CC="491") | ($CC="493")  //also in <>GLUERS below
				If (Not:C34([Estimates_Machines:20]Flex_Field5:25))
					//$lastCartons:=$lastCartons+fCalcFlatPack ($netCartons;$YldCartons)  `Examining, 
					$wantWaste:=$wantWaste+fCalcFlatPack($netCartons; $YldCartons)
					$TTLyldWaste:=$TTLyldWaste+0
					$lastGross:=($lastCartons+$TTLyldWaste+$wantWaste)/$NumberUp  //reduce to sheets        
				Else 
					$LastGross:=fCalcFlatPack($LastGross)
				End if 
				
			: (Position:C15($CC; <>GLUERS)#0)  //•060696  MLB add choices,`•090696  MLB 476 477
				//$lastCartons:=$lastCartons+fCalcGluer ($netCartons;$YldCartons;»yldWaste)
				$wantWaste:=$wantWaste+fCalcGluer($netCartons; $YldCartons; ->yldWaste)
				$TTLyldWaste:=$TTLyldWaste+yldWaste
				$lastGross:=($lastCartons+$TTLyldWaste+$wantWaste)/$NumberUp  //reduce to sheets         
				
			: (Position:C15($CC; <>WINDOWERS)>0)  // Modified by: Mel Bohince (10/10/17)  / ($CC="486") | ($CC="472")
				//$lastCartons:=$lastCartons+fCalcWindower ($netCartons;($lastCartons+$TTLyldWaste
				$wantWaste:=$wantWaste+fCalcWindower($YldCartons; ($netCartons+$wantWaste); ($YldCartons+$wantWaste); ->yldWaste; $TTLyldWaste)
				$TTLyldWaste:=$TTLyldWaste+yldWaste
				$lastGross:=($lastCartons+$TTLyldWaste+$wantWaste)/$NumberUp
				$grossWin:=$grossWin+[Estimates_Machines:20]Qty_Gross:22
				$yldWin:=uNANCheck($yldWin+(([Estimates_Machines:20]RunningHrs:32+[Estimates_Machines:20]Hrs_YldAddition:44)*[Estimates_Machines:20]RunningRate:31))
				
			: ($CC="490") | ($CC="492")
				$LastGross:=fCalcStrip($LastGross; $caliper; $NumberUp)
				
			: ($CC="496") | ($CC="497")
				$lastGross:=fCalcStraightCu($lastGross; $caliper)  //COMPLETE    
				
			: (($CC="501") | ($CC="502"))  //see 491
				If (Not:C34([Estimates_Machines:20]Flex_Field5:25))
					//$lastCartons:=$lastCartons+fCalcExam_HL ($netCartons;$YldCartons)  `add only was
					$wantWaste:=$wantWaste+fCalcExam_HL($netCartons; $YldCartons)  //add only 
					$TTLyldWaste:=$TTLyldWaste+0
					$lastGross:=($lastCartons+$TTLyldWaste+$wantWaste)/$NumberUp  //reduce to sheets        
				Else 
					$LastGross:=fCalcFlatPack($LastGross)
				End if 
				
			: ($CC="505")
				$LastGross:=fCalcGeneric($LastGross)
				
			: ($CC="581")
				$LastGross:=fCalcScreenMake($LastGross)
				
			: ($CC="583")
				$LastGross:=fCalcHeidleDieC($LastGross; $NumberUp)
				
			: ($CC="584")
				$lastGross:=fCalcHandFeed($LastGross)
				
			: ($CC="585")
				If (Not:C34([Estimates_Machines:20]Flex_Field5:25))
					//$lastCartons:=$lastCartons+fCalcStamping3 ($netCartons;$YldCartons)  ` ($lastCar
					$wantWaste:=$wantWaste+fCalcStamping3($netCartons; $YldCartons; ->yldWaste; $TTLyldWaste)
					$TTLyldWaste:=$TTLyldWaste+yldWaste
					$lastGross:=($lastCartons+$TTLyldWaste+$wantWaste)/$NumberUp  //reduce to sheets 
				Else 
					$LastGross:=$LastGross+fCalcStamping3($LastGross; $LastGross; ->yldWaste; 0)
				End if 
				
			: ($CC="888")
				$LastGross:=fCalcTransit($LastGross)
				
			Else 
				BEEP:C151
				BEEP:C151
				ALERT:C41("What the heck is a "+[Estimates_Machines:20]CostCtrID:4+"?")
				$LastGross:=fCalcGeneric($LastGross)
		End case 
	End if   //if not vFailed    
	//*.      Remove costs of Outside Service sequences
	If ([Estimates_Machines:20]OutSideService:33)  //if this machine is for an outside service zero everything UPR 1148 chip 02/10/95
		Est_MachineInit("cost")
	End if 
	
	If (Position:C15([Estimates_Machines:20]CostCtrID:4; " 401 402 403 888 442 443 888 501 502 491 493 490 492")=0)  //
		If (([Estimates_Machines:20]CostLabor:13+[Estimates_Machines:20]CostOverhead:15+[Estimates_Machines:20]CostScrap:12+[Estimates_Machines:20]CostOvertime:41)=0) & (Not:C34([Estimates_Machines:20]OutSideService:33))  //if this is NOT an outside service & $0 UPR 1148 chip 02/10/95
			BEEP:C151
			BEEP:C151
			Est_LogIt($cr+"ERROR ERROR ERROR")
			Est_LogIt("ERROR ERROR ERROR"+"THE MACHINE ESTIMATE "+[Estimates_Machines:20]CostCtrID:4+" IS MISSING COST DATA!!!")
			Est_LogIt("ERROR ERROR ERROR")
			estCalcError:=True:C214
			<>fContinue:=False:C215
			//DELAY PROCESS(Current process;60)  `delay for 1 sec for user to see
		End if 
	End if 
	
	SAVE RECORD:C53([Estimates_Machines:20])
	//*Get the next Sequence  
	NEXT RECORD:C51([Estimates_Machines:20])
End for 

//materials section
//$LFgross & $grossSheets set at sheeting 426 | 427
//*Calculate Material Costs
// Modified by: Mel Bohince (10/5/16) added sheets per cut to augument list
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
	$numMatl:=Records in selection:C76([Estimates_Materials:29])
	FIRST RECORD:C50([Estimates_Materials:29])
	
Else 
	
	ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
	$numMatl:=Records in selection:C76([Estimates_Materials:29])
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  

If (<>fContinue)
	$matlError:=Est_MaterialsCalc($numMatl; $LastGross; formWidth; formLength; $caliper; $FilmLamGaug; $FilmLamType; $grossWin; $netCartons; $grossCoat; $yldWin; $YldCartons; sheetsPerCut)
End if 
// *********************************************
//totals section
If (<>fContinue)
	//*Roll up form costs  
	RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)  //sum up totals for form
	Est_LogIt("Form Rollup")
	Est_FormCostsRollup($LastGross)
	// *********************************************
	//*Add Additional Spoilage, see upr 1045
	If (Round:C94([Estimates_DifferentialsForms:47]Addl_Spoilage:29; 5)#Round:C94(0; 5))  //then apply that amount as additional spoilage
		//TRACE
		W1:=$grossWin  //cant pass pointers to local vars  `upr 1463 3/29/95
		W2:=$grossCoat
		$LastGross:=Est_CalcSpoilage($NumberUp; formLength; $netCartons; $yldCartons; ->W1; ->W2)  //upr 1463 3/29/95
		$grossWin:=W1
		$grossCoat:=W2
		
		If (<>fContinue)
			$matlError:=Est_MaterialsCalc($numMatl; $LastGross; formWidth; formLength; $caliper; $FilmLamGaug; $FilmLamType; $grossWin; $netCartons; $grossCoat; $yldWin; $YldCartons; sheetsPerCut)
		End if 
		If (<>fContinue)
			RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)  //sum up totals for form
			Est_FormCostsRollup($LastGross)
		Else 
			Est_FormCostsinit
		End if 
	End if 
	//*Calc Spl's like plate, dies, and dups
	Est_CalcPlatesDupsDies
	
Else 
	Est_FormCostsinit
End if 

SAVE RECORD:C53([Estimates_DifferentialsForms:47])  //really have to save record to maintain constency with [machine_est]
//*Allocate costs to the cartons on the form for use by JMI records
//update totals in each Carton record
Est_FormCartonAllocation

If (Not:C34(<>fContinue))
	BEEP:C151
	BEEP:C151
	ALERT:C41([Estimates_DifferentialsForms:47]DiffFormId:3+" Calculation failed.  Check the log file for missing or"+" incorrect machine estimation data."; "Dagnabbit")
End if 

ARRAY TEXT:C222(sDieCutOpt; 0)
ARRAY LONGINT:C221(iNumUp; 0)