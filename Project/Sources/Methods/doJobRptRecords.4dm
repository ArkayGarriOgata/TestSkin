//%attributes = {"publishedWeb":true}
//(P)doJobRptRecords: Reports for WIP Job Module
//4/20/95 add WIP actual valuation report
//•071495  MLB  UPR 1672
//• 7/28/98 cs new report
//090298 mlb optional new report for wip inv
// Modified by: Mel Bohince (4/11/14)  run popular ones on server
// Modified by: Mel Bohince (7/23/14) add new Gluer Analysis
// Modified by: MelvinBohince (4/5/22) add JobSeq_Bud_v_Act

C_TEXT:C284($rptAlias)
C_DATE:C307(dDateBegin; dDateEnd)

$rptAlias:=<>whichRpt
uSetUp(1; 1)
NewWindow(636; 438; 0; 0; fNameWindow(filePtr)+" "+$rptAlias)  //" Reporting")

app_Log_Usage("log"; "Rpt"; "doJobRptRecords: "+$rptAlias)

Case of 
	: ($rptAlias="Daily Cost Center Summary")
		mRptDCS
		
	: ($rptAlias="Monthly Cost Center Sum")
		mRptMCS
		
	: ($rptAlias="Production Report")
		mRptProduction
		
	: ($rptAlias="Prod Analysis")  // Modified by: Mel Bohince (4/11/14)  run on server
		//uConfirm ("old or new?";"old";"new")
		//If (ok=1)
		//app_Log_Usage ("log";"Rpt";"Old: "+$rptAlias)
		JOB_ProductionAnalysisByCostCen
		//Else 
		//app_Log_Usage ("log";"Rpt";"New: "+$rptAlias)
		//$fileToCreate:=JobCosting_CostCenterAnalysis   //calls JOB_ProductionAnalysisByCostCen 
		//If (Length($fileToCreate)>0)
		//$err:=util_Launch_External_App ($fileToCreate)
		//End if 
		//End if 
		
	: ($rptAlias="Prod Analysis Rpt (Cum)")
		mRptPAC
		
	: ($rptAlias="Variance Analysis Summary")
		mRptVAS
		
	: ($rptAlias="WIP Inventory") | ($rptAlias="WIP Perpetual Summary")
		//uConfirm ("old or new?";"old";"new")
		//If (ok=1)
		//app_Log_Usage ("log";"Rpt";"Old: "+$rptAlias)
		If (fGetDateRange(->dDateBegin; ->dDateEnd)=1)
			rptWIPinventory(dDateBegin; dDateEnd; ""; cb1; 1)  //090298
		End if 
		
		//Else 
		//app_Log_Usage ("log";"Rpt";"New: "+$rptAlias)
		//$fileToCreate:=Job_WIP_Inventory 
		//If (Length($fileToCreate)>0)
		//$err:=util_Launch_External_App ($fileToCreate)
		//End if 
		//End if 
		
		//: ($rptAlias="OLD Job Close Out")
		//mRptCloseout2   `•041196 TJF
		
	: ($rptAlias="Job Close Out Summary")  // Modified by: Mel Bohince (4/11/14)  run on server
		//uConfirm ("old or new?";"old";"new")
		//If (ok=1)
		//app_Log_Usage ("log";"Rpt";"Old: "+$rptAlias)
		JOB_CloseoutSummary
		//Else   //timing problems
		//app_Log_Usage ("log";"Rpt";"New: "+$rptAlias)
		//$fileToCreate:=JobCosting_CloseOutSummary   //JOB_CloseoutSummary
		//If (Length($fileToCreate)>0)
		//$err:=util_Launch_External_App ($fileToCreate)
		//End if 
		//End if 
		
	: ($rptAlias="Monthly Hours Journal")
		mRptHJ
		
	: ($RptAlias="Machine Ticket Report@")
		CONFIRM:C162("Which format do you prefer?"; "Machine Log"; "Machine Ticket")
		If (OK=0)
			app_Log_Usage("log"; "Rpt"; "mMachTicketRpt:"+$rptAlias)
			mMachTicketRpt
		Else 
			app_Log_Usage("log"; "Rpt"; "rptMachineLog:"+$rptAlias)
			rptMachineLog  //•061699  mlb  UPR 2055
		End if 
		
	: ($RptAlias="WIP Actual Hours Summary")
		rRptWIP_ActHrs
		
		//: ($RptAlias="Gluer Analysis")  //•071495  MLB  UPR 1672
		//RptGlueAnalysis 
		
	: ($RptAlias="Sheeter Rate Closeout")
		Job_CloseoutSheeter  // Modified by: Mel Bohince (7/23/14)
		
	: ($RptAlias="Gluer Rate Closeout")
		Job_CloseoutGluers  // Modified by: Mel Bohince (7/23/14)
		
	: ($RptAlias="Job Close Out")
		JOB_Closeout("F")
		
		//:($RptAlias="Closeout Review")
		//JOB_Closeout ("R")
		
	: ($RptAlias="Machine Efficiencies")
		rEfficiency
		
	: ($RptAlias="PO Items by Job")  //• 7/28/98 cs new report
		rPOItemsByJob
		
	: ($RptAlias="JobItem Contributions")  //•081798  mlb  UPR 
		rptJMIcontribut
		
	: ($RptAlias="Material Variances")  //•111798  mlb  UPR 
		rJobMaterialVar
		
	: ($RptAlias="Job Variances")  //•111798  mlb  UPR 
		JOB_VarianceRpt
		
	: ($RptAlias="Machine Variances")
		rptMachineVariance
		
	: ($RptAlias="Job Bag")
		<>JFActivity:=3
		Job_JobBagReview
		//JOB_BAG_ReportPrint 
		
	: ($RptAlias="Payroll vs. Production")
		//JOB_ProductionPayRollCompare 
		
	: ($RptAlias="Daily Production")
		Job_DailyProdRpt
		
	: ($RptAlias="Daily Item Status")
		Job_GluingStatus
		
	: ($RptAlias="Daily Gluing Shortage")
		Job_GluingShort
		
	: ($rptAlias="Daily Press Report")
		JOB_dailyPressReport
		
	: ($rptAlias="Daily Press Output")
		JOB_dailyPressOutput
		
	: ($rptAlias="Just-In-Time Summary")
		JOB_JITanalysis
		
	: ($rptAlias="Material Usage")  //• mlb - 1/31/03  10:51
		Job_getMaterialIssues
		
	: ($rptAlias="Job_80_20")  //• mlb - 1/22/04  10:51
		JMI_80_20_Rpt
		
	: ($rptAlias="Combo Percent")  // Modified by: Mel Bohince (11/9/16) 
		Job_GetNumberOfCombos
		
	: ($rptAlias="Score Card Data")  // Modified by: Mel Bohince (1/25/17) 
		Job_ScoreCardData
		
	: ($rptAlias="Closeout-Commodities")  // Modified by: Mel Bohince (2/17/17) 
		JOB_CloseoutCommodities
		
	: ($rptAlias="Jobits without Pricing")  // Modified by: Mel Bohince (3/1/17) 
		JMI_FindMissingSellingPrice
		
		
	: ($rptAlias="Finishing Dept Rpt")  // Modified by: Mel Bohince (3/1/17) 
		JMI_ProductionReport
		
	: ($rptAlias="JobSeq Bud v Act")  // Modified by: MelvinBohince (4/5/22) 
		JobSeq_Bud_v_Act
		
	Else 
		ALERT:C41("Report "+$rptAlias+" is not available.")
End case 

CLOSE WINDOW:C154
UNLOAD RECORD:C212(filePtr->)
uSetUp(0; 0)