//%attributes = {"publishedWeb":true}
//(p) rExamExpctedYld
//moved code here to shorted mthend suite
//•070795 KS said to include CC
//•121495
//•031596  MLB  ks said to remove (CC + FG) sub caption

READ ONLY:C145([Customers:16])

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="Ex@"; *)
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="FG@"; *)  //was '&' 12/8/94
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
	QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]Location:2="XC@")  //•121495 KS said to include CC
	
	uRelateSelect(->[Finished_Goods:26]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1; 1)
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods:26])+" file. Please Wait...")
	QUERY:C277([Finished_Goods:26]; [Finished_Goods_Locations:35]Location:2="Ex@"; *)
	QUERY:C277([Finished_Goods:26];  | ; [Finished_Goods_Locations:35]Location:2="FG@"; *)  //was '&' 12/8/94
	QUERY:C277([Finished_Goods:26];  | ; [Finished_Goods_Locations:35]Location:2="CC@"; *)  //•070795 KS said to include CC
	QUERY:C277([Finished_Goods:26];  | ; [Finished_Goods_Locations:35]Location:2="XC@")  //•121495 KS said to include CC
	zwStatusMsg(""; "")
	
End if   // END 4D Professional Services : January 2019 query selection

ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]CustID:2; >; [Finished_Goods:26]ProductCode:1; >)

BREAK LEVEL:C302(1; 1)
ACCUMULATE:C303([Finished_Goods:26]zCount:30; real1; real2; real3; real4; real5; real6; real7; real8; real9; real10; real11; real12; real13; real14; real15)
util_PAGE_SETUP(->[Finished_Goods:26]; "FGcostingRpt4")
FORM SET OUTPUT:C54([Finished_Goods:26]; "FGcostingRpt4")
t2:="FINISHED GOODS PLUS EXAMINING EXPECTED YIELD INVENTORY"
t2b:="PERIOD ENDING "+String:C10(dDateEnd; 1)
t3:=""  //•031496  MLB  ks 

PDF_setUp(<>pdfFileName)
PRINT SELECTION:C60([Finished_Goods:26]; *)
FORM SET OUTPUT:C54([Finished_Goods:26]; "List")
READ WRITE:C146([Customers:16])