//%attributes = {"publishedWeb":true}
//PM: MthEndSuite_Reports() ->   
//formerly rRptMthEndSuite 7/7/94
//••• see also MthEndSuite_Batch
//mod 9/14/94 test and negate returns.
//mod 9/29/94 added some inventory reports
//10/4/94
//10/11/94 upr 1269
//10/13/94 InventoryReport
//12/8/94  upr 1357
//12/8/94  fix fg valuation reports
//UPR 1355 chip 12/9/94
//UPR1361 1/3/ 95chip, made call to gprintxmonthly
//1/11/95 upr 1329
//1/20/95
//1/25/95 upr 1397
//upr 1333 2/13/95 sub fg to xc for fg to ex which can't happen
//2/22/95
//2/28/95 added some calls
//3/3/95
//03/08/95 upr 999 added fg report
//03/20/95 upr 1461 chip
//3/22/95 moved all the rest of the reorts into their own procedures
//4/25/95
//•051095 
//•061295  MLB  UPR 1640
//•081795  MLB  hk request
//•091295 upr 1696
//•120495  MLB  change Cust Aged Inventory
//•030796  MLB  add new report
//•1/29/97 cs made cust ex costed yeild inv report writable to disk
//•3/3/97 cs added code to clear selections
//•120397  MLB  add UPR 239 PlantContribution
//•121197  MLB  UPR 1906
//• 1/8/98 cs new vensum report format
//•012198  MLB  UPR 1915
//• 5/19/98 cs added RM on hand w/costs
//• 6/1/98 cs made RM on hand with costs print ALL materials
//• 7/2/98 cs setu pfor this to run in its own process
//• 8/6/98 cs include wip inventory report
//•071599  mlb  UPR 2050 CoGS by location
//•072099  mlb  UPR 2056
//•090199  mlb  UPR 2054 Machine variances
//•121499  mlb  add fifo detail
// Modified by: Mel Bohince (12/2/15) remove execute on server for fifo, agedfifo

C_DATE:C307(dDateBegin; dDateEnd)
C_BOOLEAN:C305(fSave)
C_BOOLEAN:C305($FIFOregenRequired)
C_POINTER:C301($File)  //•3/3/97 cs needed for clearing selctions
C_TEXT:C284(<>pdfFileName)
C_LONGINT:C283($i)

$FIFOregenRequired:=False:C215  //run nitely in batch, or specifically run it in mth end dialog
zCursorMgr("beachBallOff")
<>iMode:=3
<>filePtr:=->[z___Kill_User_Processes:50]
uSetUp(1; 1)
//NewWindow (636;438;2;8;"Month End Suite of Reports")
windowTitle:="Month End Suite of Reports"
$winRef:=OpenFormWindow(->[zz_control:1]; "MthEndSuite_dio"; ->windowTitle; windowTitle)

If (Size of array:C274(<>MthEndSuite)=0)
	MESSAGE:C88("Initializing Report Choices...")
	arrMthEndSuite
	ERASE WINDOW:C160
End if 

ARRAY BOOLEAN:C223(ListBox1; 0)
DIALOG:C40([zz_control:1]; "MthEndSuite_dio")
If (OK=1)
	If (uNowOrDelay("Month End Suite"))
		zCursorMgr("watch")
		$started:=Current time:C178
		For ($i; 1; Size of array:C274(aSelected))
			If (aSelected{$i}="X")
				zwStatusMsg("MES"; <>MthEndSuite{$i})
				SET WINDOW TITLE:C213(<>MthEndSuite{$i})
				
				app_Log_Usage("log"; "Rpt"; "MthEndSuite_Reports: "+<>MthEndSuite{$i})
				
				<>pdfFileName:=String:C10($i; "00")+Substring:C12(<>MthEndSuite{$i}; 1; 25)+".pdf"
				Case of 
					: (<>MthEndSuite{$i}="Sales & Production Backlog")
						rBackLogRpt
					: (<>MthEndSuite{$i}="Analysis of Shipped Sales by Customer")  //mod 1/25/95 chip
						rShippingByCust  //upr 1397
					: (<>MthEndSuite{$i}="Analysis of Shipped Sales by Sales Person")  //mod 1/25/ 95 chip
						rShippingBySale  //upr 1397
					: (<>MthEndSuite{$i}="Cost of Sales by Job")  //writes to file
						rSalesbyJobCst(dDateBegin; dDateEnd; "All")  //• 2/9/98 cs added parameter indicate this call from MOS 
					: (<>MthEndSuite{$i}="Cost of Sales by Class Summary")
						rProductClass
					: (<>MthEndSuite{$i}="F/G + Examining Expected Yield Inventory")
						rExamExpctedYld
					: (<>MthEndSuite{$i}="Arkay Packaging Inventory Cost Analysis")
						rRptInvCostAnal
					: (<>MthEndSuite{$i}="Costed Finished Goods Inventory") | (<>MthEndSuite{$i}="Costed Examining Inventory") | (<>MthEndSuite{$i}="Costed Examining Expected Yield Inventory") | (<>MthEndSuite{$i}="Costed Bill & Hold Inventory")
						rCostdInventRpt($i)  //•061295  MLB  UPR 1640
						// rCostdInvRptOri ($i)  `•1/31/97 original report saved aside, remove after @6wks
					: (<>MthEndSuite{$i}="Hauppauge Costed F/G Inventory") | (<>MthEndSuite{$i}="Roanoke Costed F/G Inventory") | (<>MthEndSuite{$i}="Pay-Use Costed F/G Inventory")  //•081899  mlb  UPR 2053
						rCostdInventRpt($i)  //•081899  mlb  UPR 2053
						
					: (<>MthEndSuite{$i}="Total Purchases by Commodity (VenSum)")  //UPR 1355 changed reqdate -> poitemdate in searches
						//moved auto printing of VenSum to once every 3 months (month divisable by 3)
						//rVendorSummary   `upr 1349 1/31/95
						rNewVenSum  //• 1/8/98 cs new report format
					: (Position:C15("F/G Trans Log"; <>MthEndSuite{$i})#0)
						gFgExamTransLog($i)
					: (<>MthEndSuite{$i}="Aged F/G Inventory - F/G only")  //03/20/95 chip upr 1461 writes to file
						rRptCustAgeInv3(dDateEnd)  //2/28/95
					: (<>MthEndSuite{$i}="Aged F/G Inventory - Exam Only")
						rRptCustAgeInv3(dDateEnd; "*")  //2/28/95    writes to file
					: (<>MthEndSuite{$i}="Items Scrapped Between Dates - At Cost")
						rRptScrappedFG("COST")  //2/28/95
					: (<>MthEndSuite{$i}="Items Scrapped Between Dates - At Price")
						rRptScrappedFG("VALUE")  //2/28/95
						
					: (<>MthEndSuite{$i}="Inventory - 9 Months and Up")  //1/11/95 upr 1329
						gPrintXMonthly(9; "Inventory - 9 Months and Up")  //•081795  MLB  hk request
						
					: (<>MthEndSuite{$i}="Inventory - 12 Months and Up")
						gPrintXMonthly(12; "Inventory - 12 Months and Up")
						
					: (<>MthEndSuite{$i}="Inventory - 15 Months and Up")
						gPrintXMonthly(15; "Inventory - 15 Months and Up")
						
					: (<>MthEndSuite{$i}="Simple Inventory, Aged")  //•030796  MLB 
						rptNewInventory(6; "Inventory - 6 Months and Up"; "")
						
					: (<>MthEndSuite{$i}="Inventory Monthly (No Search)")
						rRptMthInvent("*")  //3/3/95 made into proc
						
					: (<>MthEndSuite{$i}="RM On Hand w/Cost")  //•071296  MLB remove from array
						//mRptRmOhnCost2 ("@")  `see also doRMRptRecords  2/28/95
						//RM_onHandRpt ("@";"@")
						RM_onHandRptToText
						
					: (<>MthEndSuite{$i}="Shipment Quantities by Customer & Brand")  //writes to file
						//rShipdQtyByCust   `4/25/95
						rRptShipByBrand  //•051095 
					: (<>MthEndSuite{$i}="Total Purchases by Department")  //•091295 upr 1696
						rRptDeptPurchas  //•091295 upr 1696 
						
					: (<>MthEndSuite{$i}="FG/CC/XC/EX Summary")  //•121495 KS
						rRptInvLocSum
						
					: (<>MthEndSuite{$i}="Plant Contributions")  //•120397  MLB  UPR 239   writes to file
						rRptPlantContri(dDateBegin; dDateEnd)
						
					: (<>MthEndSuite{$i}="Simple Inventory, Forecast")  //•121197  MLB  UPR 1906
						rptValuedExcess(0; "Inventory - 0 Months and Up"; "")
						
					: (<>MthEndSuite{$i}="CPI - Shipping Performance")  //•012198  MLB  UPR 1915
						CPi_Shipping(dDateBegin; dDateEnd; "All Customers")
						
					: (<>MthEndSuite{$i}="Wip Inventory")
						//rWipInventory ("*")
						rptWIPinventory(dDateBegin; dDateEnd; ""; 0; 1; "noLaunch")  //•092598  MLB  
						
					: (<>MthEndSuite{$i}="Inventory Test by Quantity")
						rptInventoryTest(dDateBegin; dDateEnd)
						
					: (<>MthEndSuite{$i}="Inventory Test by Job Cost")
						
						rptInventoryTest(dDateBegin; dDateEnd; 2)
						
					: (<>MthEndSuite{$i}="CoGS Hauppauge")  //•071599  mlb  UPR 2050
						rSalesbyJobCst(dDateBegin; dDateEnd; "Haup")
						
					: (<>MthEndSuite{$i}="CoGS Roanoke")  //•071599  mlb  UPR 2050
						rSalesbyJobCst(dDateBegin; dDateEnd; "Roan")
						
					: (<>MthEndSuite{$i}="CoGS PayUse")  //•071599  mlb  UPR 2050
						rSalesbyJobCst(dDateBegin; dDateEnd; "PayU")
						
					: (<>MthEndSuite{$i}="Job Variance")  //•082799  mlb 
						JOB_VarianceRpt(dDateBegin; dDateEnd)
						
					: (<>MthEndSuite{$i}="Machine Variances")
						rptMachineVariance(dDateBegin; dDateEnd)
						
					: (<>MthEndSuite{$i}="FIFO Regeneration")
						JIC_Regenerate("@")
						$FIFOregenRequired:=False:C215
						
					: (<>MthEndSuite{$i}="FG Inventory at FIFO")  //  
						If ($FIFOregenRequired)
							JIC_Regenerate("@")
							$FIFOregenRequired:=False:C215
						End if 
						//$fileToCreate:=FiFo_Inventory_Report   // calls JIC_inventoryRpt (1)
						//$err:=util_Launch_External_App ($fileToCreate)
						JIC_inventoryRpt
						
					: (<>MthEndSuite{$i}="FG Inventory at FIFO Detail")
						If ($FIFOregenRequired)
							JIC_Regenerate("@")
							$FIFOregenRequired:=False:C215
						End if 
						//$fileToCreate:=FiFo_Inventory_Report_Detail   //calls JIC_inventoryDetailRpt (0)
						//$err:=util_Launch_External_App ($fileToCreate)
						JIC_inventoryDetailRpt
						
					: (<>MthEndSuite{$i}="R/M Aging")
						rptRMaging
						
					: (<>MthEndSuite{$i}="FG Bin Summary")  //  ◊MthEndSuite{55}:="FG Bin Summary"
						FG_BinSummary
						
					: (<>MthEndSuite{$i}="3-6-9-12 Aged Inv Detail")  //  ◊MthEndSuite{55}:="FG Bin Summary"
						rptAgeFGdetail("ALL")
						
					: (<>MthEndSuite{$i}="3-6-9-12 Aged Inv FIFO")  //  ◊MthEndSuite{55}:="FG Bin Summary"
						If ($FIFOregenRequired)
							JIC_Regenerate("@")
							$FIFOregenRequired:=False:C215
						End if 
						//$fileToCreate:=FiFo_Aged_Inventory   // calls rptAgeFGfifo ("ALL")
						//$err:=util_Launch_External_App ($fileToCreate)
						rptAgeFGfifo
						
					: (<>MthEndSuite{$i}="THC Report")  //  ◊MthEndSuite{55}:="FG Bin Summary"
						FG_THC_Report("ALL")
						
					: (<>MthEndSuite{$i}="Purchases")  //  ◊MthEndSuite{55}:="FG Bin Summary"
						PO_LastWeeksRpt(dDateBegin; dDateEnd)
						
					: (<>MthEndSuite{$i}="WB Inline Coating Usage")  // Modified by: Mel Bohince (7/28/15) 
						//$distributionList:=Batch_GetDistributionList ("";"ACCTG")
						//$distributionList:=$distributionList+"\tchad.brafford@arkay.com"  // Modified by: Mel Bohince (12/1/16) new guy, was "Jason.Sheely@arkay.com"
						// Modified by: Garri Ogata (12/2/20) Accounting and Chad requested they be removed from this list
						$distributionList:="Christian.Yates@MarshMMA.com"
						RM_AQ_Coating_Usage(dDateBegin; dDateEnd; $distributionList)
						
					Else 
						BEEP:C151
						ALERT:C41("Failure in rRptMthEndSuite:"+Char:C90(13)+<>MthEndSuite{$i})
				End case 
				aSelected{$i}:="√"
			End if 
		End for   //each bulleted report
		
		If (fSave)
			CLOSE DOCUMENT:C267(vDoc)
		End if 
		
		BEEP:C151
		BEEP:C151
		ALERT:C41("The Monthend Suite has finished at "+String:C10(Current time:C178; HH MM AM PM:K7:5)+"."+Char:C90(13)+"Elapse: "+String:C10(Current time:C178-$started; Hour min:K7:4); "About Time")
		zwStatusMsg("MES"; "Finished at "+String:C10(Current time:C178; HH MM AM PM:K7:5)+". "+"Elapse: "+String:C10(Current time:C178-$started; Hour min:K7:4)+" Document: "+document)
	End if   //canceled delay dio
End if   //OK
ARRAY TEXT:C222(aSelected; 0)

//• 3/3/97 cs clear selections setup by the above reports
For ($i; 1; Get last table number:C254)
	If (Is table number valid:C999($i))
		$File:=Table:C252($i)
		REDUCE SELECTION:C351($File->; 0)
	End if 
End for 
//end clear mods
uWinListCleanup

zCursorMgr("restore")