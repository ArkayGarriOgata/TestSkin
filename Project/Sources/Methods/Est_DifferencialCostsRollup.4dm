//%attributes = {"publishedWeb":true}
//Est_DifferencialCostsRollup() formerly sSummarizeTotals()   -JML  8/27/93
//mod mlb 11/9/93
//update [casescenrio totals])
//•041797  mBohince  add price for breakouts
//• 4/10/98 cs nan checking
//•072998  MLB  UPR 1966 remove mach_est search

Est_LogIt("Rollup differential")
QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=[Estimates_Differentials:38]Id:1)
QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=[Customers:16]ID:1; *)  //•041797  mBohince  
QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=[Estimates:17]Brand:3)
If (<>fContinue)
	
	[Estimates_Differentials:38]CostTtlLabor:11:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]CostTtlLabor:15))
	[Estimates_Differentials:38]CostTtlOH:12:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]CostTtlOH:16))
	[Estimates_Differentials:38]CostTtlMatl:13:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]CostTtlMatl:17))
	[Estimates_Differentials:38]Cost_Overtime:17:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]Cost_Overtime:25))
	[Estimates_Differentials:38]Cost_Scrap:15:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]Cost_Scrap:24))
	[Estimates_Differentials:38]CostTTL:14:=uNANCheck([Estimates_Differentials:38]CostTtlMatl:13+[Estimates_Differentials:38]CostTtlOH:12+[Estimates_Differentials:38]CostTtlLabor:11+[Estimates_Differentials:38]Cost_Scrap:15+[Estimates_Differentials:38]Cost_RD:16+[Estimates_Differentials:38]Cost_Overtime:17)
	[Estimates_Differentials:38]Cost_Dups:19:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]Cost_Dups:20))
	[Estimates_Differentials:38]Cost_Plates:20:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]Cost_Plates:21))
	[Estimates_Differentials:38]Cost_Dies:21:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]Cost_Dies:22))
	[Estimates_Differentials:38]Cost_Yield_Adds:30:=uNANCheck(Sum:C1([Estimates_DifferentialsForms:47]Cost_Yield_Adds:27))
	[Estimates_Differentials:38]Prc_Dies:22:=Round:C94([Estimates_Differentials:38]Cost_Dies:21; 0)  //•041797  mBohince  
	[Estimates_Differentials:38]Prc_Plates:23:=Round:C94([Estimates_Differentials:38]Cost_Plates:20; 0)  //•041797  mBohince  
	[Estimates_Differentials:38]Prc_Dups:24:=Round:C94([Estimates_Differentials:38]Cost_Dups:19; 0)  //•041797  mBohince 
	
	
	If (Records in selection:C76([Customers_Brand_Lines:39])>0)
		tCalculationLog:=tCalculationLog+"Contract PV set to: "+String:C10([Customers_Brand_Lines:39]ContractPV:7; "0.000")+" PV"+Char:C90(13)
		[Estimates_Differentials:38]PriceDetails:29:=String:C10([Customers_Brand_Lines:39]ContractPV:7; "0.000")+" PV at "+TS2String(TSTimeStamp)  //+Char(13)+[Differential]PriceDetails
		REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)
	End if 
	
	//*update the differentials total qty counts
	QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=[Estimates_Differentials:38]Id:1+"@")
	//QUERY([CARTON_SPEC];[CARTON_SPEC]Estimate_No=[ESTIMATE]EstimateNo;*)  `find Esti
	//QUERY([CARTON_SPEC]; & ;[CARTON_SPEC]diffNum=[Differential]diffNum)
	[Estimates_Differentials:38]TotalPieceYld:10:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)
	[Estimates_Differentials:38]TotalPieces:8:=Sum:C1([Estimates_FormCartons:48]FormWantQty:9)
	If (estCalcError)
		If ([Estimates_Differentials:38]TotalPieces:8>0)
			[Estimates_Differentials:38]TotalPieceYld:10:=[Estimates_Differentials:38]TotalPieceYld:10*-1
			[Estimates_Differentials:38]TotalPieces:8:=[Estimates_Differentials:38]TotalPieces:8*-1
		Else 
			[Estimates_Differentials:38]TotalPieceYld:10:=-1
			[Estimates_Differentials:38]TotalPieces:8:=-1
		End if 
	End if 
	
Else   //calc aborted
	[Estimates_Differentials:38]CostTtlLabor:11:=0
	[Estimates_Differentials:38]CostTtlOH:12:=0
	[Estimates_Differentials:38]CostTtlMatl:13:=0
	[Estimates_Differentials:38]Cost_Overtime:17:=0
	[Estimates_Differentials:38]Cost_Scrap:15:=0
	[Estimates_Differentials:38]CostTTL:14:=0
	[Estimates_Differentials:38]Cost_Dups:19:=0
	[Estimates_Differentials:38]Cost_Plates:20:=0
	[Estimates_Differentials:38]Cost_Dies:21:=0
	[Estimates_Differentials:38]Cost_Yield_Adds:30:=0
	[Estimates_Differentials:38]Prc_Dies:22:=0
	[Estimates_Differentials:38]Prc_Plates:23:=0
	[Estimates_Differentials:38]Prc_Dups:24:=0
	
	[Estimates_Differentials:38]TotalPieceYld:10:=-1
	[Estimates_Differentials:38]TotalPieces:8:=-1
	
	[Estimates_Differentials:38]PriceDetails:29:="error"
	
End if 

SAVE RECORD:C53([Estimates_Differentials:38])  //save this record to maintain total consistency
//