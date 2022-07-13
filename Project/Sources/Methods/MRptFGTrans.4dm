//%attributes = {"publishedWeb":true}
//mRptFGTrans-  JML  7/15/93
//Creates a Finished goods transaction report-allows user to report on any
//combination of transactions.

$rptAlias:=<>whichRpt
SET WINDOW TITLE:C213("Finished Goods: "+$rptAlias)
MRptFGTransSrch

If (OK=1)
	util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "TransRpt")
	PRINT SETTINGS:C106
	
	If (OK=1)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
			
			CREATE SET:C116([Finished_Goods:26]; "FGSet")  //save selection because during phase searches  [finished_goods]
			
			
		Else 
			
			ARRAY LONGINT:C221($_FGSet; 0)
			LONGINT ARRAY FROM SELECTION:C647([Finished_Goods:26]; $_FGSet)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "TransRpt")
		iPage:=1
		xReptTitle:="Finished Goods-Transfer Report"
		ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2; >; [Finished_Goods_Transactions:33]JobForm:5; >; [Finished_Goods_Transactions:33]XactionDate:3; >)
		BREAK LEVEL:C302(1)
		ACCUMULATE:C303([Finished_Goods_Transactions:33]Qty:6; [Finished_Goods_Transactions:33]CoGSExtended:8; [Finished_Goods_Transactions:33]ExtendedPrice:20)
		PRINT SELECTION:C60([Finished_Goods_Transactions:33]; *)
		FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "List")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
			
			USE SET:C118("FGSet")
			CLEAR SET:C117("FGSet")
			
		Else 
			
			CREATE SELECTION FROM ARRAY:C640([Finished_Goods:26]; $_FGSet)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if 
End if 