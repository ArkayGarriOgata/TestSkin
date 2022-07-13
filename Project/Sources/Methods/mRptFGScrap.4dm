//%attributes = {"publishedWeb":true}
//mRptFGScrap()    -JML   7/93, mod 6/30 fix search
//Feel free to modify or delete this report if needed-it is not based on any 
//existing Arkay reports(although a Quality report like this was requested.)
//reports and may not be needed.  The Transfer Report can display the same kind of
//information but using a slightly different format.
//• 3/26/97 cs upr 1614 add totals and costs to report

$rptAlias:=<>whichRpt
SET WINDOW TITLE:C213("Finished Goods: "+$rptAlias)
sLinkWhat:="Return_Report"
DIALOG:C40([zz_control:1]; "DateRange2")
ERASE WINDOW:C160
If (OK=1)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Scrap")
		//QUERY([Finished_Goods_Transactions]; & ;[Finished_Goods_Transactions]Location="Sc@")
		
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28#"OBSOLETE")
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28#"EXCESS")
		
		
	Else 
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="Scrap"; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28#"OBSOLETE"; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ReasonNotes:28#"EXCESS")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	If (Records in selection:C76([Finished_Goods_Transactions:33])=0)
		ALERT:C41("Sorry, Nothing was 'scrapped' for this selection of Finished Goods.")
	Else 
		util_PAGE_SETUP(->[Finished_Goods_Transactions:33]; "RptScrap")
		PRINT SETTINGS:C106
		If (OK=1)
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
				
				CREATE SET:C116([Finished_Goods:26]; "FGSet")  //save selection because during phase searches  [finished_goods]
				
				
			Else 
				ARRAY LONGINT:C221($_FGSet; 0)
				LONGINT ARRAY FROM SELECTION:C647([Finished_Goods:26]; $_FGSet)
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "RptScrap")
			iPage:=1
			xReptTitle:="Finished Goods-Scrap Report"
			ORDER BY:C49([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3; >)
			BREAK LEVEL:C302(1)  //• 3/26/97 cs upr 1614
			ACCUMULATE:C303([Finished_Goods_Transactions:33]Qty:6; [Finished_Goods_Transactions:33]CoGSExtended:8)  //• 3/26/97 cs upr 1614
			PRINT SELECTION:C60([Finished_Goods_Transactions:33]; *)
			FORM SET OUTPUT:C54([Finished_Goods_Transactions:33]; "List")
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
				
				USE SET:C118("FGSet")
				CLEAR SET:C117("FGSet")
				
				
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([Finished_Goods:26]; $_FGSet)
				
				
			End if   // END 4D Professional Services : January 2019 query selection
			uClearSelection(->[Finished_Goods_Transactions:33])  //• 3/26/97 cs upr 1614
		End if 
	End if 
End if 