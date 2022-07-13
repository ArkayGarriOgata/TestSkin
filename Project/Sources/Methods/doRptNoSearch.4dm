//%attributes = {"publishedWeb":true}
// doReportNoSearch
//upr 1257, 1261 & 1262 10/29/94
//•041096  mBohince  allow serial printing
//• 1/8/98 cs new vensum format
//• 1/28/98 cs removed reference to rrptpo (Imagewriter driver PO form)
//• 3/19/98 cs limit printing of PO to approved POs
//• 6/30/98 cs added lead time report, moved 'laser po' to 'Purchase order'

C_TEXT:C284($1)  // doReportNoSearch
C_LONGINT:C283($2)  //0=search, 1=no search
C_TEXT:C284($rptAlias)

$rptAlias:=<>whichRpt
uSetUp(1; 1)
Open window:C153(12; 60; 492; 338; 8; $RptAlias+" Report")  //• 6/30/98 cs change to title of report

app_Log_Usage("log"; "Rpt"; "doReportNoSearch: "+$rptAlias)

Case of 
		//--- REQUISITION REPORTS     
	: ($rptAlias="Requisition")
		rPrintReq
		
		//--- PURCHASE ORDER REPORTS 
	: ($rptAlias="Purchase Order")  //• 3/19/98 cs 
		If ([Purchase_Orders:11]Status:15="Req@") | ([Purchase_Orders:11]Status:15="Rev@")
			ALERT:C41("This PO has not yet been approved"+Char:C90(13)+"To get a hardcopy of this PO, you need to print from the requision Palette.")
		Else 
			rLaserPo
		End if 
		
	: ($rptAlias="Open PO Items")
		rRptOpenPOitems
		//--- VENDOR REPORTS 
	: ($rptAlias="Outstanding POs")
		rRptVendPO
		
	: ($rptAlias="Last Week's POs")
		PO_LastWeeksRpt
		
		//--- CUSTOMER ORDER REPORTS
	: ($rptAlias="Production Activity")
		rRptProdAct
	: ($rptAlias="Preparatory Activity")
		rRptPrepAct
	: ($rptAlias="Expirations")
		rRptExpirations
	: ($RptAlias="Short Lead Times")
		rLeadTime
		//Raw MAterials Reports
	: ($rptAlias="PI RM Count Sheet")
		
		RMLc_Dialog_Pick  //Creates current selection in [Raw_Materials_Locations]
		
		If (OK=1)  //Print
			
			CREATE SET:C116([Raw_Materials_Locations:25]; "RawMaterialsLocations")
			
			rPiRmCountSheet("RawMaterialsLocations")
			
			$err:=util_Launch_External_App(docName)
			
			CLEAR SET:C117("RawMaterialsLocations")
			
		End if   //Done print
		
	: ($rptAlias="Allocation Report")
		//uConfirm ("New or Old Allocation Report";"New";"Old")
		//If (ok=1)
		RM_AllocationRpt_UI  // Modified by: Mel Bohince (11/4/21) 
		//Else 
		//RM_AllocationRpt   //("01-SBS.18")
		//End if 
		
	: ($rptAlias="Issue Log")
		mRptRMIssue
	: ($rptAlias="Receiving Log")
		rRptRMreceipts
	: ($rptAlias="Return Log")
		rRptRMreturns
	: ($rptAlias="Batch Log")
		rRptRMbatches
	: ($rptAlias="Adjustment Log")
		rRptRMadjustmen
	: ($RptAlias="Ven Sum Report")
		//rVendorSummary ("*")  `upr 1349
		rNewVenSum("*")  //• 1/8/98 cs new vensum format
	: ($RptAlias="Dept Sum Report")
		rRptDeptPurchas("*")  //upr 1696
	: ($RptAlias="New Ven Sum")
		rNewVenSum("*")  //upr 1349    
	: ($RptAlias="Auto Issue Log")
		rPostingLog
	: ($RptAlias="RePrint Post Exceptions")
		rAIssExceptions("R")  //• 3/3/98 cs R= reprint
	: ($RptAlias="Wip Inventory")
		//rWipInventory `•092598  MLB  use new one
		rptWIPinventory
		
	: ($RptAlias="PH77144 Usage")  // Modified by: Mel Bohince (6/6/17) name changed // Modified by: Mel Bohince (7/28/15) 
		RM_AQ_Coating_Usage
		
	: ($rptAlias="Open Order Backlog")
		Ord_backlog
		
	: ($rptAlias="No Cost Order Lines")
		OL_NoCostWarning
		
	: ($rptAlias="YTD Billings")  // Modified by: Mel Bohince (10/11/18) 
		INV_YTD_Billings_Export
		
End case 
CLOSE WINDOW:C154
UNLOAD RECORD:C212(filePtr->)
// uClearTextVars
uSetUp(0; 0)