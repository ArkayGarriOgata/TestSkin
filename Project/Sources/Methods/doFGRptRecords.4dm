//%attributes = {"publishedWeb":true}
//doFGRptRecords() -JML  7/15/93
//see also uInitPopupsRpts, rRptMthEndSuite
//Called from FGEvent layout, this generates any of a number of Finished Goods rep
//The logic here is somewhat different than other Reporting processes- part of the
//reason is that some reports are really searching on [FG_transactions] rather
//than [Finished_goods]
//upr 1357 12/8/94 run uniterupted in MES
//1/11/94 upr 1329 aged inventory stuff
//upr1330 1/12/95 need to mfg
//upr 1432 chip 02/15/95
//upr 1439 2/22/95
//2/23/95 
//2/23/95 upr 1439
//added for upr 02/23/95
//4/25/95 upr 147
//•080195  MLB  UPR 213
//•081795  MLB  hk request
//•082295  MLB HK request for aged excess
//•091395 MLB KS request for bin status
//•120495  MLB  changed Cust Aged Inv
//•022597  MLB  try to clear some stuff
//• 2/28/97 cs added new report upr 1848
//•121197  MLB  UPR 1906
//• 2/9/98 cs added cost of good sold report
//•111798  mlb  UPR add a report

C_TEXT:C284($rptAlias)  // doFGRptRecords
C_DATE:C307(dDateBegin; dDateEnd)

$rptAlias:=<>whichRpt
uSetUp(1; 1)
Open window:C153(2; 40; 638; 478; 8; fNameWindow(filePtr)+" "+$rptAlias)  //" Reporting")

app_Log_Usage("log"; "Rpt"; "doFGRptRecords: "+$rptAlias)

Case of 
	: ($rptAlias="Profile Report")  //OBSOLETE
		NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
		If (OK=1)
			SET WINDOW TITLE:C213(fNameWindow(filePtr)+" "+$rptAlias)
			mRptFG
		End if 
		
	: ($rptAlias="Stock Status Report")
		NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
		If (OK=1)
			SET WINDOW TITLE:C213(fNameWindow(filePtr)+" "+$rptAlias)
			mRptStkSt
		End if 
		
	: ($rptAlias="Bin Status Report")
		SET WINDOW TITLE:C213($rptAlias)
		mRptBinSt
		
	: ($rptAlias="Obsoleted CPN's to Scrap")  //de
		rRptFGobsoletes
		
	: ($rptAlias="Customer Inv. Summary")  //OBSOLETE
		rRptCustInvSum  //2/23/95  upr 1439
		
	: ($rptAlias="Customer Aged Inventory")  //OBSOLETE
		//rRptCustAgeInv2   `2/23/95 upr 1439
		rRptCustAgeInv3  //•031496  MLB 
		
	: ($rptAlias="Customer Excess Inventory")  //OBSOLETE
		rRptCustInvExs  //•080195  MLB  UPR 213
		
	: ($rptAlias="Material Movement Report")  //OBSOLETE
		NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
		If (OK=1)
			SET WINDOW TITLE:C213(fNameWindow(filePtr)+" "+$rptAlias)
			mRptMtrlMov
		End if 
		
		//: ($rptAlias="Reject-Listing")
		//mRptFGReturns 
		
		//: ($rptAlias="Reject-Customer Summary")  //Examining change made
		//mRptFGReturns2 
		
		//: ($rptAlias="Reject-Reason Summary")  //Examining change made
		//mRptFGReturns3 
		
	: ($rptAlias="Scrap-Listing")  //Examining change made
		mRptFGScrap
		
	: ($rptAlias="Transfer Report")  //Examining change made
		MRptFGTrans
		
		//: ($rptAlias="Open Releases")  //Need to Manufacture
		//  //rRptOpenRels 
		
		//: ($rptAlias="Open Releases - 2")  //Need to Manufacture
		//  //rRptOpenRels2 
		
		//: ($rptAlias="Need to Manufacture")  //Need to Manufacture
		//  //rRptNeed2MFG 
		
		//: ($rptAlias="Need to Mfg without Rel")  //upr1330 1/11/95
		//  //rRptNeed2MFGwo   //upr1330 1/11/95
		
		//: ($rptAlias="Need to Mfg by M.A.D.")  //upr1330 1/12/95
		//  //rRptJobMad   //upr1330 1/12/95    
		
		//: ($rptAlias="Need to Mfg by Job Nº")  //•072695  MLB 
		//  //rRptJobMad ("*")  //•072695  MLB  
		
		//: ($RptAlias="UnPlanned Production")  //• 2/28/97 cs upr 1848 //OBSOLETE
		//  //rUnPlannedRpt 
		
		//: ($RptAlias="Need to Produce")  // • mel (10/14/04, 11:06:32)
		//  //FG_NeedToProduce 
		
		//: ($rptAlias="Inventory Monthly")  //upr 1357 12/8/94 //OBSOLETE
		//  //rRptMthInvent   //3/3/95 make as proc
		
		//: ($rptAlias="Daily Shipment Review")  //OBSOLETE
		//gReveiwManifest 
		
		//: ($RptAlias="Cust & Brand Shipments")  //4/25/95
		//uDialog ("SelectCust";250;170)
		//If (False)
		//FORM SET INPUT([zz_control];"SelectCust")
		//End if 
		
		//If (OK=1)
		//rRptShipByBrand (dDateBegin;dDateEnd;sCust)
		//End if 
		
		//: ($RptAlias="Inventory - X Months & Up")  //OBSOLETE
		//uDialog ("SelectXMonth";255;200)  //•081795  MLB  hk request
		//If (False)
		//FORM SET INPUT([zz_control];"SelectXMonth")
		//End if 
		
		//If (OK=1)
		//gPrintXMonthly (rReal1;t2;"*")  //1/11/94 upr 1329 `•081795  MLB  hk request
		//End if 
		
		//: ($rptAlias="Simple Inventory, Aged")  //•082295  MLB HK request //OBSOLETE
		//rptNewInventory 
		
		//: ($rptAlias="Simple Inventory, Excess")  //•071796  MLB HK request //OBSOLETE
		//rptNewInventor2 
		
		//: ($rptAlias="Aged Excess")  //•082295  MLB HK request //OBSOLETE
		//rRptAgedExcess Method deleted by: Mel Bohince (1/29/19)
		
	: ($RptAlias="Order/Inv Summary")  //OBSOLETE
		rOrderSummary
		
	: ($RptAlias="Mary Kay")  //rMaryKay4  ` rMaryKay3     //OBSOLETE 
		rMaryKay5
		
	: ($RptAlias="Arden Report")  //rMaryKay4  ` rMaryKay3     
		OL_Arden_Rpt
		
	: ($RptAlias="Proctor & Gamble")  //OBSOLETE
		//rProctorAndGamble now PnG_OrigRpt
		CONFIRM:C162("Run Min/Max Report?"; "Yes"; "No")
		If (OK=1)
			PnG_MinMaxRpt  //081000mlb
		End if 
		CONFIRM:C162("Run Over 60 Day Report?"; "Yes"; "No")
		If (OK=1)
			PnG_Billable60Day
		End if 
		
	: ($RptAlias="Chanel")  //OBSOLETE
		rChanelRpt
		
	: ($RptAlias="Simple Inventory, Forecast")  //•121197  MLB  UPR 1906 //OBSOLETE
		rptValuedExcess
		
	: ($RptAlias="Cost of Goods Sold")
		rSalesbyJobCst
		
	: ($RptAlias="Yet another Customer Liability")
		rptAllFuckers
		
	: ($RptAlias="3-6-9-12 Aged Inv Detail")  //•111398  mlb  UPR  //OBSOLETE
		rptAgeFGdetail
		CONFIRM:C162("Run Customer Kill Reports?"; "Yes"; "No")
		If (OK=1)
			FG_KillReport
		End if 
		
	: ($RptAlias="Kill Report")
		FG_KillReport
		
	: ($RptAlias="Kill Tickets")
		FG_KillTickets
		
	: ($RptAlias="FiFo Shipping Test")  //batched
		FG_CheckFiFoShipment
		
	: ($RptAlias="3-6-9-12 Aged Inv FiFo")  //•mel: 06/01/05, 09:03:53
		//uConfirm ("Age all inventory or search?";"All";"Search")
		//If (OK=1)
		//$fileToCreate:=FiFo_Aged_Inventory   // calls rptAgeFGfifo ("ALL")
		//$err:=util_Launch_External_App ($fileToCreate)
		rptAgeFGfifo  // Modified by: Mel Bohince (12/2/15) 
		uConfirm("Do the Excess & Costed versions?"; "Yes"; "No")
		If (OK=1)
			rptAgeFGfifo_excess  // ("ALL")
			rptAgeFGfifo_costed  //("ALL")
		End if 
		
		//Else 
		//rptAgeFGfifo 
		//rptAgeFGfifo_excess 
		//rptAgeFGfifo_costed 
		//End if 
		
	: ($RptAlias="FG Inv, Ords, and Forecasts")  //•111798  mlb  UPR 
		rFGdataDump
		
	: ($RptAlias="FG_Location_Export")  // Modified by: MelvinBohince (2/3/22) 
		FG_Location_Export
		
	: ($RptAlias="William Lea Extract")  //•111798  mlb  UPR 
		FG_William_Lea_Rpt
		
	: ($RptAlias="DelFor Comparison")  //•111798  mlb  UPR  //OBSOLETE
		FG_DelforComparison
		
	: ($RptAlias="THC Report")  // • mel (6/30/05, 11:14:24)
		FG_THC_Report
		
	: ($RptAlias="On-Time Report")  //•111798  mlb  UPR 
		REL_OntimeReport
		REL_OntimeReportCustomerView(dDateBegin; dDateEnd; "@")
		
	: ($RptAlias="Prep Report")  //•111798  mlb  UPR 
		distributionList:=Email_WhoAmI(Current user:C182)
		If (Length:C16(distributionList)>0)
			Batch_PrepWeekly(distributionList)
		Else 
			BEEP:C151
			ALERT:C41("Couldn't figure out your email address.")
		End if 
		
	: ($RptAlias="Hoops Weeks Covered")  //•111798  mlb  UPR  //OBSOLETE
		MartyLastRun
		
	: ($RptAlias="PI F/G Count Sheet")
		<>filePtr:=->[Finished_Goods_Locations:35]
		rPIFgCountSheet
		
	: ($RptAlias="Flat eXcess Report")  //•111798  mlb  UPR  //OBSOLETE
		FG_FXexcessRpt
		
	: ($RptAlias="Bill & Hold Report")  //•111798  mlb  UPR 
		FG_Bill_and_Hold_Report
		
	: ($RptAlias="Cayey & BrownSummit Inventory")  //•111798  mlb  UPR 
		Rama_rptInventories
		
	: ($RptAlias="Shipto's Inventory")  // Modified by: Mel Bohince 04/24/15, 12:24:32
		FG_Inventory_by_Shipto
		
	: ($RptAlias="A# Analysis")  // Modified by: Mel Bohince 09/21/17, 10:44:22 
		JMI_A_Number_Stats
		
	: ($RptAlias="YTD Shipments")  // Modified by: Mel Bohince (10/3/17) 
		REL_YTD_Shipments
		
End case 

CLOSE WINDOW:C154
UNLOAD RECORD:C212(filePtr->)
uSetUp(0; 0)

uClearSelection(->[Finished_Goods:26])  //•022597  MLB  
uClearSelection(->[Finished_Goods_Transactions:33])
uClearSelection(->[Finished_Goods_Locations:35])
uClearSelection(->[Customers:16])
uClearSelection(->[Customers_Order_Lines:41])
uClearSelection(->[Job_Forms:42])


