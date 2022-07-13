//%attributes = {}
// Method: MthEndSuite_Batch (date) -> 
// ----------------------------------------------------
// by: mel: 12/09/04, 16:33:41
// ----------------------------------------------------
// Description:
// based on MthEndSuite_Reports
// this one differs by running without ui and emailing some reports
// ----------------------------------------------------
// Modified by: Mel Bohince (12/2/15) remove execute on server for fifo, agedfifo
// Modified by: Mel Bohince (11/9/16) add timestamp to file names for storeage to remote Accounting volume, symbolic link from ams_documents to monthend drive
//intranet:~ ladmin$ ln -s /Volumes/Accounting/Month\ End /Users/ladmin/Documents/AMS_Documents
//   +fYYMMDD (4D_Current_date)+"_"+Replace string(String(4d_Current_time;<>HHMM);":";"")+".xls"
// Modified by: Mel Bohince (5/4/21) date of run controlled by bBatch_Runner
// Modified by: Garri Ogata (9/23/21) email RM_OnHandRptToText and rptWIPInventory to Batch_GetDistributionList ("";"ACCTG")

C_DATE:C307($batch_run_date; $1)  // Modified by: Mel Bohince (5/4/21) date of run controlled by bBatch_Runner
$batch_run_date:=$1

C_BOOLEAN:C305($FIFOregenRequired)
C_TEXT:C284(<>pdfFileName; $fileToCreate)

If (Size of array:C274(<>MthEndSuite)=0)
	MESSAGE:C88("Initializing Report Choices...")
	arrMthEndSuite
End if 
ARRAY TEXT:C222(aSelected; Size of array:C274(<>MthEndSuite))
For ($i; 1; Size of array:C274(aSelected))
	aSelected{$i}:="X"
End for 


aSelected{1}:=""  //"Sales & Production Backlog"
//aSelected{2}:=""  `"Cost of Sales by Job"
aSelected{3}:=""  //"Analysis of Shipped Sales by Customer" 
//4 used `"Analysis of Shipped Sales by Sales Person" 

aSelected{5}:=""  //"Shipment Quantities by Customer & Brand"
aSelected{6}:=""  //"Shipment Quantities by Customer & Brand"
aSelected{7}:=""  //"Shipment Quantities by Customer & Brand"
aSelected{8}:=""  //"Costed Finished Goods Inventory" see FIFO
aSelected{9}:=""  //"Costed Bill & Hold Inventory"
aSelected{10}:=""  //"Costed Examining Inventory"
aSelected{11}:=""  //"Costed Examining Expected Yield Inventory"
aSelected{12}:=""  //"EX Expected Yield Inventory"
aSelected{13}:=""  //"F/G Trans Log - WIP to CC"
aSelected{14}:=""  //"F/G Trans Log - CC to FG"
aSelected{15}:=""  //15 used"F/G Trans Log - FG to SC"
aSelected{16}:=""  //16 used"F/G Trans Log - CC to SC"
aSelected{17}:=""  //"F/G Trans Log - CC to EX"
aSelected{18}:=""  //18 used"F/G Trans Log - EX to SC"
aSelected{19}:=""  //"F/G Trans Log - EX to XC" 
aSelected{20}:=""  //20 used"F/G Trans Log - XC to SC"
aSelected{21}:=""  //"F/G Trans Log - XC to FG"
aSelected{22}:=""  //"F/G Trans Log - XC to EX"
aSelected{23}:=""  //aSelected{23}:=""  `"F/G Trans Log - XC to EX"
aSelected{24}:=""  //"F/G Trans Log - Customer to EX"
aSelected{25}:=""  //"F/G Trans Log - Customer to FG"
aSelected{26}:=""  //"Aged F/G Inventory - F/G Only"`"
aSelected{27}:=""  //"Aged F/G Inventory - Exam Only"
aSelected{28}:=""  //"Items Scrapped Between Dates - At Cost"
aSelected{29}:=""  //"Items Scrapped Between Dates - At Price"
aSelected{30}:=""  //"Inventory - 9 Months and Up"
aSelected{31}:=""  //"Inventory - 12 Months and Up"
aSelected{32}:=""  //"Inventory - 15 Months and Up"
aSelected{33}:=""  //"Inventory Monthly (No Search)"
aSelected{34}:=""  //"Inventory Monthly (No Search)"
aSelected{35}:=""  //"Total Purchases by Department"
//36 used"FG/CC/XC/EX Summary" 
aSelected{37}:=""  //"Simple Inventory, Aged"
aSelected{38}:=""  //"Plant Contributions"
aSelected{39}:=""  //"Simple Inventory, Forecast
aSelected{40}:=""  //cpi
//aSelected{41}:=""  //"RM On Hand w/Cost" 
//42 wip inventory
aSelected{43}:=""  //inv test
aSelected{44}:=""  //inv test

aSelected{45}:=""  //cogs h
aSelected{46}:=""  //cogs r
aSelected{47}:=""  //cogs payu

aSelected{48}:=""  //costing
aSelected{49}:=""  //costing r
aSelected{50}:=""  //costing payu
aSelected{51}:=""  //"Job Variance"
aSelected{52}:=""  //"Machine Variances"

aSelected{53}:=""  //"FIFO Regeneration"
//54 used"FG Inventory at FIFO"
aSelected{55}:=""  //"FG Inventory at FIFO Detail"
//aSelected{56}:=""  `"R/M Aging"
aSelected{57}:=""  //"FG Bin Summary"
aSelected{58}:=""  //"3-6-9-12 Aged Inv Detail"
//59 used"3-6-9-12 Aged Inv FIFO"
aSelected{60}:=""  //"THC Report"
aSelected{61}:=""  //"Purchases"
//aSelected{62}:=""  //"WB Inline Coating Usage"

<>iMode:=3
<>filePtr:=->[x_Usage_Stats:65]
uSetUp(1; 1)
C_LONGINT:C283($i)

document:=""
$month:=String:C10(Month of:C24($batch_run_date))  // Modified by: Mel Bohince (5/5/21) 
$year:=String:C10(Year of:C25($batch_run_date))  // Modified by: Mel Bohince (5/5/21) 
dDateBegin:=Date:C102($month+"/1/"+$year)
dDateEnd:=Date:C102($month+"/"+String:C10(<>aDaysInMth{Num:C11($month)})+"/"+$year)

document:="mes."+fYYMMDD(dDateEnd)
vDoc:=util_putFileName(->document)
fSave:=True:C214
<>PrintToPDF:=True:C214
C_LONGINT:C283($macPDF; $printer)
$macPDF:=3
$prefPath:=util_DocumentPath
$pdfDocName:="aMsOutput"+String:C10(TSTimeStamp)+".pdf"
SET PRINT OPTION:C733(Destination option:K47:7; $macPDF; ($prefPath+$pdfDocName))
$FIFOregenRequired:=True:C214
//$FIFOregenRequired:=False
For ($i; 1; Size of array:C274(aSelected))
	If (aSelected{$i}="X")
		zwStatusMsg("MES"; <>MthEndSuite{$i})
		SET WINDOW TITLE:C213(<>MthEndSuite{$i})
		utl_Logfile("BatchRunner.Log"; "--ME RPT START "+<>MthEndSuite{$i})
		<>pdfFileName:=String:C10($i; "00")+Substring:C12(<>MthEndSuite{$i}; 1; 25)+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".pdf"
		Case of 
				
			: (<>MthEndSuite{$i}="Analysis of Shipped Sales by Sales Person")  //mod 1/25/ 95 chip
				$distributionList:=Batch_GetDistributionList(""; "A/R")
				rShippingBySale($distributionList)  //upr 1397
				
			: (<>MthEndSuite{$i}="Cost of Sales by Job")  //writes to file
				rSalesbyJobCst(dDateBegin; dDateEnd; "All")  //X 2/9/98 cs added parameter indicate this call from MOS 
				
			: (<>MthEndSuite{$i}="RM On Hand w/Cost")  //X071296  MLB remove from array
				//mRptRmOhnCost2 ("@")  `see also doRMRptRecords  2/28/95
				//RM_onHandRpt ("@";"@")
				
				RM_onHandRptToText(Batch_GetDistributionList(""; "ACCTG"))  // Modified by: Garri Ogata (9/23/21) email
				
			: (<>MthEndSuite{$i}="Wip Inventory")
				
				rptWIPinventory(dDateBegin; dDateEnd; ""; 0; 1; "noLaunch"; Batch_GetDistributionList(""; "ACCTG"))  // Modified by: Garri Ogata (9/23/21) email
				//rptWIPinventory (dDateBegin;dDateEnd;"";0;1;"noLaunch")  //X092598  MLB  
				
				//$fileToCreate:=Job_WIP_Inventory (String(dDateEnd))  // Modified by: Mel Bohince (4/21/14) 
				If (False:C215)
					
				End if 
				
			: (<>MthEndSuite{$i}="FG/CC/XC/EX Summary")  //X121495 KS
				$distributionList:=Batch_GetDistributionList(""; "ACCTG")
				rRptInvLocSum($distributionList)
				
			: (<>MthEndSuite{$i}="FIFO Regeneration")
				JIC_Regenerate("@")
				$FIFOregenRequired:=False:C215
				
			: (<>MthEndSuite{$i}="FG Inventory at FIFO")  //
				If ($FIFOregenRequired)
					utl_Logfile("BatchRunner.Log"; "--ME RPT ++ FIFO Regeneration")
					JIC_Regenerate("@")
					$FIFOregenRequired:=False:C215
				End if 
				//$fileToCreate:=FiFo_Inventory_Report   // calls JIC_inventoryRpt (1)  // Modified by: Mel Bohince (3/25/14) email to darlene
				$distributionList:=Batch_GetDistributionList(""; "ACCTG")
				JIC_inventoryRpt($distributionList)
				//EMAIL_Sender ("FIFO Inventory Monthly";"";"Advance copy attached";$distributionList;$fileToCreate)
				
			: (<>MthEndSuite{$i}="R/M Aging")
				//rptRMaging // Modified by: Mel Bohince (12/2/15) 
				<>pdfFileName:="RM_Aging_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".pdf"
				docName:=rptRMaging(1; <>pdfFileName)
				
			: (<>MthEndSuite{$i}="3-6-9-12 Aged Inv FIFO")  //  ◊MthEndSuite{55}:="FG Bin Summary"
				If ($FIFOregenRequired)
					utl_Logfile("BatchRunner.Log"; "--ME RPT ++ FIFO Regeneration")
					JIC_Regenerate("@")
					$FIFOregenRequired:=False:C215
				End if 
				//$fileToCreate:=FiFo_Aged_Inventory   // calls rptAgeFGfifo ("ALL")
				$distributionList:=Batch_GetDistributionList(""; "ACCTG")
				rptAgeFGfifo($distributionList)
				
			: (<>MthEndSuite{$i}="WB Inline Coating Usage")  // Modified by: Mel Bohince (7/28/15) 
				//$distributionList:=Batch_GetDistributionList ("";"ACCTG")
				//$distributionList:=$distributionList+"\tchad.brafford@arkay.com"  // Modified by: Mel Bohince (12/1/16) new guy, was "Jason.Sheely@arkay.com"
				// Modified by: Garri Ogata (12/2/20) Accounting and Chad requested they be removed from this list
				$distributionList:="Christian.Yates@MarshMMA.com"  // Modified by: Mel Bohince (10/15/20) 
				RM_AQ_Coating_Usage(dDateBegin; dDateEnd; $distributionList)
				
			: (False:C215)
				// OBSOLETE:::?????
				
				//: (<>MthEndSuite{$i}="Sales & Production Backlog")
				//rBackLogRpt 
				//: (<>MthEndSuite{$i}="Analysis of Shipped Sales by Customer")  //mod 1/25/95 chip
				//rShippingByCust   //upr 1397
				//: (<>MthEndSuite{$i}="Cost of Sales by Class Summary")
				//rProductClass 
				//: (<>MthEndSuite{$i}="F/G + Examining Expected Yield Inventory")
				//rExamExpctedYld 
				//: (<>MthEndSuite{$i}="Arkay Packaging Inventory Cost Analysis")
				//rRptInvCostAnal 
				//: (<>MthEndSuite{$i}="Costed Finished Goods Inventory") | (<>MthEndSuite{$i}="Costed Examining Inventory") | (<>MthEndSuite{$i}="Costed Examining Expected Yield Inventory") | (<>MthEndSuite{$i}="Costed Bill & Hold Inventory")
				//rCostdInventRpt ($i)  //X061295  MLB  UPR 1640
				//  // rCostdInvRptOri ($i)  `X1/31/97 original report saved aside, remove after @6wks
				//: (<>MthEndSuite{$i}="Hauppauge Costed F/G Inventory") | (<>MthEndSuite{$i}="Roanoke Costed F/G Inventory") | (<>MthEndSuite{$i}="Pay-Use Costed F/G Inventory")  //X081899  mlb  UPR 2053
				//rCostdInventRpt ($i)  //X081899  mlb  UPR 2053
				
				//: (<>MthEndSuite{$i}="Total Purchases by Commodity (VenSum)")  //UPR 1355 changed reqdate -> poitemdate in searches
				//  //moved auto printing of VenSum to once every 3 months (month divisable by 3)
				//  //rVendorSummary   `upr 1349 1/31/95
				//rNewVenSum   //X 1/8/98 cs new report format
				//: (Position("F/G Trans Log";<>MthEndSuite{$i})#0)
				//gFgExamTransLog ($i)
				//: (<>MthEndSuite{$i}="Aged F/G Inventory - F/G only")  //03/20/95 chip upr 1461 writes to file
				//rRptCustAgeInv3 (dDateEnd)  //2/28/95
				//: (<>MthEndSuite{$i}="Aged F/G Inventory - Exam Only")
				//rRptCustAgeInv3 (dDateEnd;"*")  //2/28/95    writes to file
				//: (<>MthEndSuite{$i}="Items Scrapped Between Dates - At Cost")
				//rRptScrappedFG ("COST")  //2/28/95
				//: (<>MthEndSuite{$i}="Items Scrapped Between Dates - At Price")
				//rRptScrappedFG ("VALUE")  //2/28/95
				
				//: (<>MthEndSuite{$i}="Inventory - 9 Months and Up")  //1/11/95 upr 1329
				//gPrintXMonthly (9;"Inventory - 9 Months and Up")  //X081795  MLB  hk request
				
				//: (<>MthEndSuite{$i}="Inventory - 12 Months and Up")
				//gPrintXMonthly (12;"Inventory - 12 Months and Up")
				
				//: (<>MthEndSuite{$i}="Inventory - 15 Months and Up")
				//gPrintXMonthly (15;"Inventory - 15 Months and Up")
				
				//: (<>MthEndSuite{$i}="Simple Inventory, Aged")  //X030796  MLB 
				//rptNewInventory (6;"Inventory - 6 Months and Up";"")
				
				//: (<>MthEndSuite{$i}="Inventory Monthly (No Search)")
				//rRptMthInvent ("*")  //3/3/95 made into proc
				
				
				
				//: (<>MthEndSuite{$i}="Shipment Quantities by Customer & Brand")  //writes to file
				//  //rShipdQtyByCust   `4/25/95
				//rRptShipByBrand   //X051095 
				//: (<>MthEndSuite{$i}="Total Purchases by Department")  //X091295 upr 1696
				//rRptDeptPurchas   //X091295 upr 1696 
				
				
				
				//: (<>MthEndSuite{$i}="Plant Contributions")  //X120397  MLB  UPR 239   writes to file
				//rRptPlantContri (dDateBegin;dDateEnd)
				
				//: (<>MthEndSuite{$i}="Simple Inventory, Forecast")  //X121197  MLB  UPR 1906
				//rptValuedExcess (0;"Inventory - 0 Months and Up";"")
				
				//: (<>MthEndSuite{$i}="CPI - Shipping Performance")  //X012198  MLB  UPR 1915
				//CPi_Shipping (dDateBegin;dDateEnd;"All Customers")
				
				//: (<>MthEndSuite{$i}="Inventory Test by Quantity")
				//rptInventoryTest (dDateBegin;dDateEnd)
				
				//: (<>MthEndSuite{$i}="Inventory Test by Job Cost")
				
				//rptInventoryTest (dDateBegin;dDateEnd;2)
				
				//: (<>MthEndSuite{$i}="CoGS Hauppauge")  //X071599  mlb  UPR 2050
				//rSalesbyJobCst (dDateBegin;dDateEnd;"Haup")
				
				//: (<>MthEndSuite{$i}="CoGS Roanoke")  //X071599  mlb  UPR 2050
				//rSalesbyJobCst (dDateBegin;dDateEnd;"Roan")
				
				//: (<>MthEndSuite{$i}="CoGS PayUse")  //X071599  mlb  UPR 2050
				//rSalesbyJobCst (dDateBegin;dDateEnd;"PayU")
				
				//: (<>MthEndSuite{$i}="Job Variance")  //X082799  mlb 
				//JOB_VarianceRpt (dDateBegin;dDateEnd)
				
				//: (<>MthEndSuite{$i}="Machine Variances")
				//rptMachineVariance (dDateBegin;dDateEnd)
				
				//: (<>MthEndSuite{$i}="FG Inventory at FIFO Detail")
				//If ($FIFOregenRequired)
				//JIC_Regenerate ("@")
				//$FIFOregenRequired:=False
				//End if 
				//$distributionList:=Batch_GetDistributionList ("";"ACCTG")
				//JIC_inventoryDetailRpt ($distributionList)
				//$fileToCreate:=FiFo_Inventory_Report_Detail   //calls JIC_inventoryDetailRpt (0)
				//EMAIL_Sender ("FIFO Detail Monthly";"";"Advance copy attached";"mel.bohince@arkay.com";$fileToCreate)
				
				
				//: (<>MthEndSuite{$i}="FG Bin Summary")  //  ◊MthEndSuite{55}:="FG Bin Summary"
				//FG_BinSummary 
				
				//: (<>MthEndSuite{$i}="3-6-9-12 Aged Inv Detail")  //  ◊MthEndSuite{55}:="FG Bin Summary"
				//rptAgeFGdetail ("ALL")
				
				
				//: (<>MthEndSuite{$i}="THC Report")  //  ◊MthEndSuite{55}:="FG Bin Summary"
				//FG_THC_Report ("ALL")
				
				//: (<>MthEndSuite{$i}="Purchases")  //  ◊MthEndSuite{55}:="FG Bin Summary"
				//PO_LastWeeksRpt (dDateBegin;dDateEnd)
				
				
			Else 
				BEEP:C151
				//ALERT("Failure in MthEndSuite_Batch:"+Char(13)+<>MthEndSuite{$i})
		End case 
		aSelected{$i}:="√"
		
		utl_Logfile("BatchRunner.Log"; "---ME RPT END "+<>MthEndSuite{$i})
		
	End if 
	
End for   //each bulleted report

CLOSE DOCUMENT:C267(vDoc)
ARRAY TEXT:C222(aSelected; 0)
For ($i; 1; Get last table number:C254)  //• 3/3/97 cs clear selections setup by the above reports
	If (Is table number valid:C999($i))
		$File:=Table:C252($i)
		REDUCE SELECTION:C351($File->; 0)
	End if 
End for 