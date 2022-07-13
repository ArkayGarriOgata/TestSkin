//%attributes = {"publishedWeb":true}
//(p) rRptInvCostAnal(ysis)
//this is just transplanted code to short the mnt end suite code
//•070795 KS said to include CC
//•121495 KS said to include XC
//•050196  MLB  use std open orders query
//•072399  mlb  UPR 2053 total each warehouse

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@")  //•121495 KS said to include XC
//QUERY SELECTION([FG_Locations];[FG_Locations]Location="FG:AV@")
CREATE SET:C116([Finished_Goods_Locations:35]; "candidates")

<>OrdBatchDat:=!00-00-00!
BatchOrdcalc

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	USE SET:C118("candidates")
	QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:AV@")
	
Else 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:AV@")
	
End if   // END 4D Professional Services : January 2019 query selection


ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >; [Finished_Goods_Locations:35]ProductCode:1; >)
BREAK LEVEL:C302(2)
ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9; real1; real2; real3; real4; real5; real6; real7; real8; real9; [Finished_Goods_Locations:35]zCount:18)
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "CostAnalysisRpt")
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "CostAnalysisRpt")
t2:="ARKAY PACKAGING INVENTORY COST ANALYSIS"
t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
t3:="(FG:AV@ (Consignments) LOCATIONS ONLY)"  //AND C/E ONLY)"
MESSAGES OFF:C175
PDF_setUp(<>pdfFileName)
PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	USE SET:C118("candidates")
	QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"@:R@"; *)
	QUERY SELECTION:C341([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"FG:AV@")
	
	
Else 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)  //•121495 KS said to include XC
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"@:R@"; *)
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"FG:AV@")
	
	
End if   // END 4D Professional Services : January 2019 query selection
ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >; [Finished_Goods_Locations:35]ProductCode:1; >)
BREAK LEVEL:C302(2)
ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9; real1; real2; real3; real4; real5; real6; real7; real8; real9; [Finished_Goods_Locations:35]zCount:18)
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "CostAnalysisRpt")
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "CostAnalysisRpt")
t2:="ARKAY PACKAGING INVENTORY COST ANALYSIS"
t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
t3:="(HAUPPAUGE FG, CC, & XC LOCATIONS ONLY)"  //AND C/E ONLY)"
MESSAGES OFF:C175
$periodAt:=Position:C15("."; <>pdfFileName)
$filename:=Change string:C234(<>pdfFileName; "2"; ($periodAt-1))
PDF_setUp($filename)
PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	USE SET:C118("candidates")
	QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="@:R@")
	
	
Else 
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@"; *)  //•121495 KS said to include XC
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="@:R@")
	
	
End if   // END 4D Professional Services : January 2019 query selection
ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >; [Finished_Goods_Locations:35]ProductCode:1; >)
BREAK LEVEL:C302(2)
ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9; real1; real2; real3; real4; real5; real6; real7; real8; real9; [Finished_Goods_Locations:35]zCount:18)
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "CostAnalysisRpt")
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "CostAnalysisRpt")
t2:="ARKAY PACKAGING INVENTORY COST ANALYSIS"
t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
t3:="(ROANOKE FG, CC, & XC LOCATIONS ONLY)"  //AND C/E ONLY)"
MESSAGES OFF:C175
$periodAt:=Position:C15("."; <>pdfFileName)
$filename:=Change string:C234(<>pdfFileName; "3"; ($periodAt-1))
PDF_setUp($filename)
PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")

<>OrdBatchDat:=!00-00-00!
BatchOrdcalc
USE SET:C118("candidates")
ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19; >; [Finished_Goods_Locations:35]ProductCode:1; >)
BREAK LEVEL:C302(2)
ACCUMULATE:C303([Finished_Goods_Locations:35]QtyOH:9; real1; real2; real3; real4; real5; real6; real7; real8; real9; [Finished_Goods_Locations:35]zCount:18)
util_PAGE_SETUP(->[Finished_Goods_Locations:35]; "CostAnalysisRpt")
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "CostAnalysisRpt")
t2:="ARKAY PACKAGING INVENTORY COST ANALYSIS"
t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
t3:="(ALL FG, CC, & XC LOCATIONS)"  //AND C/E ONLY)"
MESSAGES OFF:C175
PRINT SELECTION:C60([Finished_Goods_Locations:35]; *)
FORM SET OUTPUT:C54([Finished_Goods_Locations:35]; "List")