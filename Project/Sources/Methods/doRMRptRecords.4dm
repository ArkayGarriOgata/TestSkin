//%attributes = {"publishedWeb":true}
//(p) doRmRptRecords
//• 4/18/97 cs upr 1856 put different interface on 'on-hand' reports

C_TEXT:C284($rptAlias)  // doRMRptRecords

$rptAlias:=<>whichRpt
uSetUp(1; 1)
Open window:C153(2; 40; 508; 538; 8; fNameWindow(filePtr)+" Reporting")

If ($rptAlias="Raw Material Catalog")  //use generic search routine ONLY if catalog
	NumRecs1:=fSelectBy  //generic search equal or range on any four fields 
Else   //on-hand now have their own searching/selection interface
	OK:=1
End if 

app_Log_Usage("log"; "Rpt"; "doRmRptRecords: "+$rptAlias)

If (OK=1)  //performed search  
	SET WINDOW TITLE:C213(fNameWindow(filePtr)+" "+$rptAlias)
	
	Case of 
		: ($rptAlias="Raw Material Catalog")
			mRptRM
			
		: ($rptAlias="RM On Hand Export")  //"On-Hand by Location")
			//NewWindow (350;100;6;5)
			//DIALOG([RM_BINS];"WhichRpt")
			//CLOSE WINDOW
			Case of 
				: (True:C214)  // Modified by: MelvinBohince (2/3/22) 
					RM_onHandRptToText  // Modified by: MelvinBohince (2/3/22) 
					
				: (False:C215)
					RM_onHandbyLocation  //•4/25/00  mlb 
					
				: (False:C215)
					mRptRMLocat2  //• 4/18/97 cs call new procedure - remove old if no problem in 6 
			End case 
			
		: ($rptAlias="On-Hand by Commodity")
			//NewWindow (350;100;6;5)
			//DIALOG([RM_BINS];"WhichRpt")
			//CLOSE WINDOW
			Case of 
				: (True:C214)
					RM_onHandRpt  //`•4/25/00  mlb  
				: (rb2=1)
					mRptRmOhnCost2  //• 4/18/97 cs call new procedure - remove old if no problem in 
			End case 
			
			//: ($rptAlias="Open-Order Report")
			//mRptRMItem 
			//: ($rptAlias="RM Group Report")
			//mRptRMGP       
			//: ($rptAlias="Items Report (By Group)")
			// mRptRMGrp    
			
		: ($rptAlias="RM Aging")
			<>pdfFileName:="RM_Aging.pdf"
			rptRMaging(1)
			
		: ($rptAlias="Allocation Report")
			//RM_AllocationRpt   //("01-SBS.18")
			RM_AllocationRpt_UI  // Modified by: Mel Bohince (11/4/21)
			
		: ($rptAlias="Inventory Equation")
			RM_InventoryEquation
			
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
			
		: ($RptAlias="LaserCam Statement")
			RM_LaserCam  // Modified by: Mel Bohince (8/2/16) 
			
		: ($RptAlias="RM Transaction Export")
			RM_TransactionExport  // Modified by: Mel Bohince (7/12/17) 
			
		: ($RptAlias="Roll Stock")
			RIM_Physical_InventoryRpt
			
	End case 
	CLOSE WINDOW:C154
End if   //ok search

UNLOAD RECORD:C212(filePtr->)
// uClearTextVars
uSetUp(0; 0)