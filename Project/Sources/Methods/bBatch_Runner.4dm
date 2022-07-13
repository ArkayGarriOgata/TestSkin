//%attributes = {"publishedWeb":true}
//Procedure: bBatch_Runner()  022197  MLB
//provide a common entry point to run a series of 
//batch routines at a certain time.
//via button on AdminEvnet.Maint Page
//•101597  MLB  contract order acceptance, and add cheezey progress indicator
//• 11/5/97 cs new issuing system
//•012198  MLB  UPR 1915 Customer Perception Index - Shipping
//•012298  MLB  Update Art and OKs in JobMasterLog
//•021898  MLB  add Glue Counts
//• 4/16/98 cs added FG GL income code updates
//•070898  MLB  added EDI Clean up
//• 8/5/98 cs added export of new customer to imaging
//•100898  mlb  UPR 1989 over issue warning
//•042299  MLB  configurable email
//•2/02/00  mlb  UPR 77
// • mel (12/09/04, 16:03:14) make live 24/7
//mel 12/5/05 add on err call
//mel 071107 make sure x_FixJMIFormClosed2 only runs once
// mel 05/23/13 save the current date into var at the beginning of run incase it goes paste midnight
// Modified by: Mel Bohince (5/4/21) pass the date of run to MthEndSuite_Batch to prevent next day execution
// Modified by: Garri Ogata (9/1/21) Add check for completion of batch runner
// Modified by: Garri Ogata (9/11/21) Commented out Batch_Bookings_by_Line (382) not needed

C_LONGINT:C283($i; $numBatches; $show; <>WMS_GET_PID; <>FLEX_EXCHG_PID; $winRef)
C_TEXT:C284(distributionList)  //•042299  MLB  configurable email
C_DATE:C307($batch_run_date)  // mel 05/23/13 save the current date into var at the beginning of run incase it goes paste midnight
C_BOOLEAN:C305(<>delayCanceled; debug)

If (Current user:C182="Administrator")  // Added by: Mark Zinke (11/19/12)
	wms_start_from_menu
	
	//PS_Exchange_Data_with_Flex 
	
	Rel_MustShip
	
	//REL_RequestForModePerDest   // Removed by: Mel Bohince (7/2/20) cut over to new asn method // Modified by: Mel Bohince (7/18/20) re-enabled
	
	//EDI_DESADV_aka_ASN   // Removed by: Mel Bohince (7/15/20) 
	
	JOB_ProdPerformance
	
End if 

SET MENU BAR:C67(<>DefaultMenu)
Batch_RunnerGetOptions
<>delayCanceled:=False:C215
debug:=False:C215
$winRef:=Open form window:C675([zz_control:1]; "BatchInterface"; 8; On the right:K39:3; At the bottom:K39:6)  //•101597  MLB
rememberI1:=1
rememberI2:=1
rememberI3:=1
delayUntilTime:=?23:00:00?
delayUntilDate:=Current date:C33
delayUntil:=TSTimeStamp(delayUntilDate; delayUntilTime)

Repeat 
	
	ERASE WINDOW:C160($winRef)
	
	//EMAIL_Daemon 
	
	DIALOG:C40([zz_control:1]; "BatchInterface")  //•101597  MLB 
	rememberI1:=i1
	rememberI2:=i2
	rememberI3:=i3
	If (OK=1)
		//**** setup for next run
		$windowTitle:="Running "
		If ((i1+i2+i3)>0)  //standard set
			If (i1=1)
				//Batch_runnerDaily ("√")
				Batch_RunnerGetSet(->[y_batches:10]Daily:5; "X")
				$windowTitle:=$windowTitle+"Daily "
			Else 
				//Batch_runnerDaily ("")
				Batch_RunnerGetSet(->[y_batches:10]Daily:5; "")
			End if 
			
			If (i2=1)
				If (Day number:C114(Current date:C33)=Friday:K10:17)  //use client date
					//Batch_runnerWeekly ("√")
					Batch_RunnerGetSet(->[y_batches:10]Weekly:6; "X")
					$windowTitle:=$windowTitle+"Weekly "
				Else 
					//Batch_runnerWeekly ("")
					Batch_RunnerGetSet(->[y_batches:10]Weekly:6; "")
				End if 
			Else 
				//Batch_runnerWeekly ("")
				Batch_RunnerGetSet(->[y_batches:10]Weekly:6; "")
			End if 
			
			If (i3=1)
				If (Day of:C23(Current date:C33+1)=1)  //use client date
					//Batch_runnerMonthly ("√")
					Batch_RunnerGetSet(->[y_batches:10]Monthly:7; "X")
					$windowTitle:=$windowTitle+"Monthly "
				Else 
					//Batch_runnerMonthly ("")
					Batch_RunnerGetSet(->[y_batches:10]Monthly:7; "")
				End if 
			Else 
				//Batch_runnerMonthly ("")
				Batch_RunnerGetSet(->[y_batches:10]Monthly:7; "")
			End if 
			
		Else   //custom run, do whatever is marked
			$windowTitle:=$windowTitle+"Custom Set "
		End if 
		SET WINDOW TITLE:C213($windowTitle; $winRef)
		
		//zCursorMgr ("beachBallOff")
		
		$numBatches:=0
		For ($i; 1; Size of array:C274(asBull))  //count how many are set to go
			If (asBull{$i}="X")
				$numBatches:=$numBatches+1
			End if 
		End for 
		ERASE WINDOW:C160($winRef)
		MESSAGE:C88("  "+String:C10($numBatches)+" ready to run:"+<>CR)
		For ($show; 1; Size of array:C274(asBull))  //ui feedbak
			If (asBull{$show}="X")
				MESSAGE:C88(asBull{$show}+" "+aCustName{$show}+<>CR)
			End if 
		End for 
		
		$Did_FiFO:=False:C215  //only do it regen or incr, not both
		$batch_run_date:=Current date:C33  // want the local date so we can run post hoc
		
		C_LONGINT:C283(batchErr; currentBatch)
		C_BOOLEAN:C305(FixedJMIFormClosed2)  //used by x_FixJMIFormClosed2 so it only runs once per batch
		FixedJMIFormClosed2:=False:C215
		ON ERR CALL:C155("eBatchError")
		batchErr:=0
		currentBatch:=0
		
		C_OBJECT:C1216($oOption)
		$oOption:=New object:C1471()
		$oOption.bStartChecking:=True:C214
		$oOption.nBatchProcessID:=Current process:C322
		
		Batch_CheckSuccess($oOption)  //Added to check success of run
		
		For ($i; 1; Size of array:C274(asBull))  //run every thing that is marked
			currentBatch:=$i
			If (asBull{$i}="X")  //ui feedbak and log it
				ERASE WINDOW:C160($winRef)
				MESSAGE:C88("  "+String:C10($numBatches)+" remaining to run:"+<>CR)
				For ($show; 1; Size of array:C274(asBull))
					If (asBull{$show}="X") | (asBull{$show}="-")
						MESSAGE:C88("   "+asBull{$show}+" "+aCustName{$show}+<>CR)
					End if 
				End for 
				utl_Logfile("BatchRunner.Log"; "START "+aCustName{$i})
			End if 
			
			Case of 
				: (debug)
					If (asBull{$i}="X")
						zwStatusMsg("Beep"; "Pretending to run "+aCustName{$i})
						DELAY PROCESS:C323(Current process:C322; 10)
					End if 
					
				: (asBull{$i}="X") & (aCustName{$i}="Set JMI Act to 1")
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					//distributionList:="Jim the Man <Jim.Bethin@arkay.com>"+Char(9)  
					//«`Batch_GetDistributionList (aCustName{$i})
					Batch_JMIActual("Zeros")
					JMI_setCompletes
					
				: (asBull{$i}="X") & (aCustName{$i}="Update Last Releases")
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					BatchSetLastRel
					
				: (asBull{$i}="X") & (aCustName{$i}="Update Orderline Qty w/Release")
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					BatchSetQtyWrel
					REL_WarnBadOrderStatus($batch_run_date)  // Modified by: Mel Bohince (1/23/15) 
					
				: (asBull{$i}="X") & (aCustName{$i}="Create Forecasts")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					BatchForecastNeedDate($batch_run_date)
					
				: (asBull{$i}="X") & (aCustName{$i}="Set Orderline Need Date")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					Batch_OrderLineNeedDate
					
				: (asBull{$i}="X") & (aCustName{$i}="Time Horizon Calculation")
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					REL_NoWeekEnds
					If (False:C215)  //for useing Search callers
						BatchTHCcalc
					End if 
					$pid:=Execute on server:C373("BatchTHCcalc"; <>lMinMemPart; "BatchTHCcalc"; "no log")  // Modified by: Mark Zinke (11/15/12) Execute on Server now.
					HR_ChgOfStatusNotices
					Arden_CheckForSpecNeeded
					ams_DeleteUserPref(30)
					//wms_DailyMaintenance 
					//don't send somethings so frequently
					$weekday:=Day number:C114($batch_run_date)  //sunday is 1
					Case of 
						: ($weekday=Sunday:K10:19)
							<>pdfFileName:="RM_Aging_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".pdf"  //"RM_Aging.pdf"
							docName:=rptRMaging(1; <>pdfFileName)
							distributionList:=Batch_GetDistributionList("RM Aging"; "RM_AGING")
							//distributionList:="mel.bohince@arkay.com"
							xText:="Attached R/M Aging Report"
							EMAIL_Sender("Aged Raw Materials"; ""; xText; distributionList; docName)
							util_deleteDocument(docName)
							
							//(Sunday PM) the "Job Closeout Summary" Report to Chris Haymaker
							distributionList:=Batch_GetDistributionList("JCOS"; "ACCTG")
							//distributionList:="mel.bohince@arkay.com"
							dDateBegin:=$batch_run_date-7  //sunday before last
							dDateEnd:=dDateBegin+6  //last saturday
							JOB_CloseoutSummary(""; distributionList; ""; dDateBegin; dDateEnd)
							
							distributionList:="john.sheridan@arkay.com, mel.bohince@arkay.com"
							RMX_PlatesReport(dDateBegin; dDateEnd; distributionList)  // Modified by: Mel Bohince (12/7/17) 
							
							//(Sunday PM) the "FG Inventory at FIFO" Report to Chris Haymaker
							distributionList:=Batch_GetDistributionList("JCOS"; "ACCTG")
							//distributionList:="mel.bohince@arkay.com"
							JIC_inventoryRpt(distributionList)
							
							distributionList:=Batch_GetDistributionList("ACCPLN"; "ACCPLN")
							JMI_FindMissingSellingPrice($batch_run_date; distributionList)
							
							
						: ($weekday=Monday:K10:13)
							Job_trackProofsLineTrials  //kk, fc
							
							//Sheeter Rate Closeout, send on Monday for prior Sunday – Saturday this report to BH, KK, TC , CH
							distributionList:=Batch_GetDistributionList("SHEETER"; "ADD_SHEET")
							//distributionList:="mel.bohince@arkay.com"
							dDateBegin:=$batch_run_date-8  //sunday before last
							dDateEnd:=dDateBegin+6  //last saturday
							Job_CloseoutSheeter(dDateBegin; dDateEnd; distributionList)
							
							distributionList:=Batch_GetDistributionList("Abandoned At Dock")  //: (asBull{$i}="X") & (aCustName{$i}="Abandoned At Dock") 
							FGL_AbandonedAtDock
							
							MESSAGE:C88("   "+aCustName{$i}+<>CR)
							distributionList:=Batch_GetDistributionList("Goal Printing")
							PS_PrintGoal("Printing")
							distributionList:=Batch_GetDistributionList("Goal Blanking")
							PS_PrintGoal("Blanking")  // Modified by: Mel Bohince (10/5/16) 
							distributionList:=Batch_GetDistributionList("Goal Stamping")
							PS_PrintGoal("Stamping")  // Modified by: Mel Bohince (10/5/16) 
							
						: ($weekday=Tuesday:K10:14)
							//Excuse-card base data, send Tue nite
							distributionList:=Batch_GetDistributionList("SCORE"; "ACCTG")
							//distributionList:="mel.bohince@arkay.com"
							dDateBegin:=$batch_run_date-9  //sunday before last
							dDateEnd:=dDateBegin+6  //last saturday
							Job_ScoreCardData(dDateBegin; dDateEnd; distributionList)
							
						: ($weekday=Wednesday:K10:15)
							
						: ($weekday=Thursday:K10:16)
							Job_trackProofsLineTrials
							
							distributionList:=Batch_GetDistributionList("Abandoned At Dock")
							FGL_AbandonedAtDock
							
						: ($weekday=Friday:K10:17)
							//dDateEnd:=4D_Current_date  //friday
							//dDateBegin:=dDateEnd-6
							//$distributionList:=Batch_GetDistributionList ("LaserCam";"A/P")
							//RM_LaserCam (dDateBegin;dDateEnd;$distributionList)  // Modified by: Mel Bohince (8/2/16) 
							
						: ($weekday=Saturday:K10:18)
							//Job_WIP_Kanban ("mel.bohince@arkay.com")  //shows me the progress of the sheets thru the plant, easy to copy/paste to Trello
							
					End case 
					
				: (asBull{$i}="X") & (aCustName{$i}="Close Customer Orders")
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					CloseCustOrders
					
				: (asBull{$i}="X") & (aCustName{$i}="Remove Orphaned Requisitioned Rms")
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					BatchNewRMClean
					
				: (asBull{$i}="X") & (aCustName{$i}="Accept Contract Orders")  //•101597  MLB  
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					BatchAcptContra
					//REL_RequestForModeRpt (distributionList)  // Modified by: Mel Bohince (2/18/16) added // Removed by: Mel Bohince (11/5/21) 
					
				: (asBull{$i}="X") & (aCustName{$i}="Material Issuing")  //• 11/5/97 cs   
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_VFIssue
					
				: (asBull{$i}="X") & (aCustName{$i}="CPI - Shipping")  //•012198  MLB  UPR 1915
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					CPi_Shipping
					//••••also runs REL_noticeOfMissedShipment
					
				: (asBull{$i}="X") & (aCustName{$i}="Update Art & OKs")  //•012298  MLB  
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_ArtandOKs($batch_run_date)
					// Modified by: Mel Bohince (4/13/16) move next line here instead of by itself
					JML_setPressDatefromSched("update printing")  //• mlb - 5/24/02  10:15
					
				: (asBull{$i}="X") & (aCustName{$i}="Glue Counts")  //•012298  MLB  
					MESSAGE:C88("    "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					FG_rptGlueCounts($batch_run_date)
					
				: (asBull{$i}="X") & (aCustName{$i}="FG GL Income Codes")  //• 4/16/98 cs 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					BatchGLIncome
					
				: (asBull{$i}="X") & (aCustName{$i}="EDI Clean-up")  //•070898  MLB  
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					BatchEDICleanUp
					
				: (asBull{$i}="X") & (aCustName{$i}="Customer Update to Imaging")  //•070898  MLB  
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_Cust2Imag
					
				: (asBull{$i}="X") & (aCustName{$i}="RM Over issue warning")  //•100898  mlb  UPR 1989 over issue warning
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					BatchRMwarning($batch_run_date)
					
				: (asBull{$i}="X") & (aCustName{$i}="Snapshot Inventory")  //•100898  mlb  UPR 1989 over issue warning
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_SnapShotInventory
					
				: (asBull{$i}="X") & (aCustName{$i}="Job Variance")  //•100898  mlb  UPR 1989 over issue warning
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					dDateBegin:=UtilGetDate($batch_run_date; "ThisMonth")
					JOB_VarianceRpt(dDateBegin; $batch_run_date)
					JobSeq_Bud_v_Act("init"; distributionList; dDateBegin; $batch_run_date)  // Modified by: Mel Bohince (10/13/17) 
					
				: (asBull{$i}="X") & (aCustName{$i}="PO Completeness")  //•100898  mlb  UPR 1989 over issue warning
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					Batch_PO_Completeness  //execute on server checkbox set on meth props
					
				: (asBull{$i}="X") & (aCustName{$i}="Close Jobs")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					CloseJobHdrs
					
				: (asBull{$i}="X") & (aCustName{$i}="Customer Activity")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					Batch_CustomerActivity
					
				: (asBull{$i}="X") & (aCustName{$i}="FIFO Net Change")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					//JIC_NetChange 
					JIC_Regenerate("@")
					$Did_FiFO:=True:C214  //don't do an increment also
					
				: (asBull{$i}="X") & (aCustName{$i}="FIFO Regeneration")  //Monthly
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					JIC_Regenerate("@")  //executes on server via Method Properties
					$Did_FiFO:=True:C214  //don't do an increment also
					
				: (asBull{$i}="X") & (aCustName{$i}="Customer Bookings")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_Bookings($batch_run_date)
					//Batch_Bookings_by_Line ($batch_run_date). 
					Cust_BnB_Data($batch_run_date)
					//export the orderlines
					Bookings2(New object:C1471("fiscal"; $batch_run_date; "distributionList"; Batch_GetDistributionList(""; "A/R")))
					
					OL_NoCostWarning($batch_run_date; $batch_run_date; distributionList)
					
					INV_setCoGSActual_batch(0)  // Modified by: MelvinBohince (5/19/22) 
					
					// Modified by: Mel Bohince (11/4/21) send this YTD every day
					INV_YTD_Billings_Export(Date:C102("01-01-"+String:C10(Year of:C25($batch_run_date))); $batch_run_date; Batch_GetDistributionList(""; "A/R"))
					
					$distributionList:=Batch_GetDistributionList("LaserCam"; "A/P")
					RM_LaserCam($batch_run_date; $batch_run_date; $distributionList)  // Modified by: Mel Bohince (8/2/16)
					
					Batch_SetCustOpenOrders
					
				: (asBull{$i}="X") & (aCustName{$i}="Consignment Status")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_Consignments($batch_run_date)
					
				: (asBull{$i}="X") & (aCustName{$i}="FIFO Incremental") & (Not:C34($Did_FiFO))  //Daily
					
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					//JIC_IncrementalRegen (distributionList)
					JIC_Regenerate("@")
					$Did_FiFO:=True:C214
					
				: (asBull{$i}="X") & (aCustName{$i}="Daily Item Status")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					JMI_setCashFlow
					Job_GluingStatus(distributionList)
					Job_GluingShort(distributionList)  //uses its own dist list "Daily Shortages"
					JOB_CloseNotice(distributionList)
					Job_WIP_Kanban("mel.bohince@arkay.com")
					JMI_excessPromoGlued($batch_run_date; distributionList)
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
						
						ams_DeleteWithoutHeaderRecord(->[WMS_ItemMasters:123]LOT:3; ->[Finished_Goods_Locations:35]Jobit:33)
						
					Else 
						
						If (<>fContinue)
							
							READ ONLY:C145([Finished_Goods_Locations:35])
							ALL RECORDS:C47([Finished_Goods_Locations:35])
							READ WRITE:C146([WMS_ItemMasters:123])
							ARRAY TEXT:C222($_Jobit; 0)
							DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $_Jobit)
							SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
							QUERY WITH ARRAY:C644([WMS_ItemMasters:123]LOT:3; $_Jobit)
							SET QUERY DESTINATION:C396(Into current selection:K19:1)
							ALL RECORDS:C47([WMS_ItemMasters:123])
							CREATE SET:C116([WMS_ItemMasters:123]; "allRecords")
							DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
							USE SET:C118("keepThese")
							CLEAR SET:C117("allRecords")
							CLEAR SET:C117("keepThese")
							
							util_DeleteSelection(->[WMS_ItemMasters:123])
							
						End if 
						
					End if   // END 4D Professional Services : January 2019 
					
					If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
						
						ams_DeleteWithoutHeaderRecord(->[WMS_Compositions:124]Container:1; ->[WMS_ItemMasters:123]Skidid:1)
						
					Else 
						
						If (<>fContinue)
							
							READ ONLY:C145([WMS_ItemMasters:123])
							ALL RECORDS:C47([WMS_ItemMasters:123])
							ARRAY TEXT:C222($_Skidid; 0)
							DISTINCT VALUES:C339([WMS_ItemMasters:123]Skidid:1; $_Skidid)
							READ WRITE:C146([WMS_Compositions:124])
							SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
							QUERY WITH ARRAY:C644([WMS_Compositions:124]Container:1; $_Skidid)
							SET QUERY DESTINATION:C396(Into current selection:K19:1)
							ALL RECORDS:C47([WMS_Compositions:124])
							CREATE SET:C116([WMS_Compositions:124]; "allRecords")
							DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
							USE SET:C118("keepThese")
							CLEAR SET:C117("allRecords")
							CLEAR SET:C117("keepThese")
							util_DeleteSelection(->[WMS_Compositions:124])
							
						End if 
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					Job_setComponentJobType  // Modified by: Mel Bohince (3/7/17) 
					Invoice_ZeroFiFoCoGS($batch_run_date)
					FG_ChkInventoryBal("dateRange"; $batch_run_date; $batch_run_date)
					
				: (asBull{$i}="X") & (aCustName{$i}="RM Allocations")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					Batch_RM_Allocations  //(distributionList)
					Batch_TransactionOnClosedJob($batch_run_date)  //send to Dan
					
				: (asBull{$i}="X") & (aCustName{$i}="Scheduled Production")  //daily
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_ScheduledProduction(distributionList)
					Batch_FGclearPressDate
					Job_SetNeedDate
					FG_SetGluerDemand
					Job_SetStartDate  // Modified by: Mel Bohince (6/15/16) 
					
				: (asBull{$i}="X") & (aCustName{$i}="Missed Closing Dates")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					JML_EmailMissedClosing(distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="Expediter Daily")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_ExpediterDaily(distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="Forecast Analysis")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_ForecastAnalysis(distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="Prep Weekly")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_PrepWeekly(distributionList; ($batch_run_date-6); $batch_run_date)
					ORD_SpecialBillingUnBilled  // Modified by: Mel Bohince (7/22/16)
					
				: (asBull{$i}="X") & (aCustName{$i}="Prep Monthly")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					$theDate:=Day of:C23($batch_run_date)  // • mel (11/17/04, 14:53:39)
					
					If ($theDate<5)  //use last month
						$theDate:=Day of:C23($batch_run_date)
						dDateEnd:=$batch_run_date-$theDate
						$theDate:=Day of:C23(dDateEnd)-1
						dDateBegin:=dDateEnd-$theDate
					Else 
						$theDate:=Day of:C23($batch_run_date)-1
						dDateBegin:=$batch_run_date-$theDate  //the 1st
						dDateEnd:=Add to date:C393(dDateBegin; 0; 1; 0)-1  //the last
					End if 
					Batch_PrepWeekly(distributionList; dDateBegin; dDateEnd)
					
				: (asBull{$i}="X") & (aCustName{$i}="On Time Weekly")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					//• mlb - 11/20/02  16:07`• mlb - 11/20/02  16:07 backdate by 3 days for chanel
					REL_OntimeReport(($batch_run_date-7); ($batch_run_date-0); "@"; 2; distributionList)
					FG_ChkInventoryBal
					
					
					If (False:C215)
						REL_OntimeReportCustomerView(($batch_run_date-10); ($batch_run_date-4); "@"; 2; distributionList)
					End if 
					
				: (asBull{$i}="X") & (aCustName{$i}="On Time  Monthly")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					$date:=$batch_run_date  //• mlb - 08/06/07
					While (Day number:C114($date)#Friday:K10:17)  //back up to a friday so that uncorrected releases are not reported
						$date:=$date-1
					End while 
					REL_OntimeReport(Add to date:C393($date; 0; -1; 0); $date; "@"; 2; distributionList)
					
					If (False:C215)
						REL_OntimeReportCustomerView(($batch_run_date-36); ($batch_run_date-5); "@"; 2; distributionList)
					End if 
					FLUSH CACHE:C297
					RMX_assignCostCenters
					MT_getCounts  // Modified by: Mel Bohince (6/10/15) 
					
					
				: (asBull{$i}="X") & (aCustName{$i}="JML_BatchUpdate")  // Modified by: Mel Bohince (4/13/16) moved up to update art & ok
					//MESSAGE("   "+aCustName{$i}+<>CR)
					//JML_BatchUpdate
					
					
				: (asBull{$i}="X") & (aCustName{$i}="60 Inventory Notice")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					FG_NoticeOfOldInventory
					
				: (asBull{$i}="X") & (aCustName{$i}="90 Day Rollover")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					FG_NoticeOfNow90
					
				: (asBull{$i}="X") & (aCustName{$i}="Open Rels & JMLs")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					REL_OpenReportToDisk(distributionList)
					JML_OpenToDisk(distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="JMI_80_20 Ship v. Stock")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					JMI_80_20_Rpt((Add to date:C393($batch_run_date; 0; -4; 0)); (Add to date:C393($batch_run_date; 0; -3; 0)))
					
				: (asBull{$i}="X") & (aCustName{$i}="On Time Notice")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					REL_noticeOfOntimeMiss(distributionList)
					distributionList:=Batch_GetDistributionList("Mfg'd Ontime")
					JMI_ontimeTest
					//distributionList:=Batch_GetDistributionList ("HRD Ontime")
					//JML_HRDreport `this is stupid report that marty wanted
					
				: (asBull{$i}="X") & (aCustName{$i}="Customer Portal Extract")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//CUSTPORT_ExportODBC 
					CUSTPORT_ExportPortal  //v1.0.3-PJK (2/26/20) run both
					//CUSTPORT_Export 
					//CUSTPORT_WMS ("png_inventory_ams")
					
				: (asBull{$i}="X") & (aCustName{$i}="Send Invoices to EL")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//Invoice_sendToEsteeLauder 
					//FLUSH BUFFERS
					//this was never implemented by Lauder
					
				: (asBull{$i}="X") & (aCustName{$i}="Auto Prep Billing")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					FG_PrepServiceAutoContractInv
					
					$numOrdernumbers:=FG_PrepServiceAutoInvoice  //prep the arrays
					QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=$batch_run_date)
					If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
						DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]OrderNumber:2; aOrderNumbers)
						REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
						For ($order; 1; Size of array:C274(aOrderNumbers))
							QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=aOrderNumbers{$order})  //ordno set in apiinvtrans
							READ WRITE:C146([Customers_Order_Lines:41])
							RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)  //get orderlines        
							Invoice_NonShippingItem("*")
						End for 
					End if 
					
				: (asBull{$i}="X") & (aCustName{$i}="FiFo Shipping Test")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					FG_CheckFiFoShipment($batch_run_date)
					
					If (False:C215)  // Modified by: Mel Bohince (9/11/14) 
						distributionList:=Batch_GetDistributionList(""; "ACCTG")
						//Rama_canJobClose ($batch_run_date)
						Rama_IssueCostToJobBatch($batch_run_date)
					End if 
					
				: (asBull{$i}="X") & (aCustName{$i}="Test FiFO Monthly")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					FG_CheckFiFoShipmentsMthly((Add to date:C393($batch_run_date; 0; -1; 0)+1); $batch_run_date)
					
				: (asBull{$i}="X") & (aCustName{$i}="Monthly Reports")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					MthEndSuite_Batch($batch_run_date)  // Modified by: Mel Bohince (5/5/21) delay past midnight is a problem 
					
					//: (asBull{$i}="X") & (aCustName{$i}="FX Excess Report")
					//MESSAGE("   "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					//FG_FXexcessRpt (distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="Check A/R")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//Invoice_CheckIfPaid 
					//av_accounts_receivable ("request")
					//need an SQL expansion license on the AV server
					//av_accounts_receivable_v2 
					
				: (asBull{$i}="X") & (aCustName{$i}="EL DESPATCH ADVICE")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					$numberOfASNs:=EDI_AdvanceShipNotice($batch_run_date)
					If ($numberOfASNs>0)  // Modified by: Mel Bohince (11/12/19) 
						utl_Logfile("BatchRunner.Log"; String:C10($numberOfASNs)+" ASN's generated")
					End if 
					//: (asBull{$i}="X") & (aCustName{$i}="Usage Statistics")  `•100898  mlb  UPR 1989 over issue warning
					//MESSAGE("   "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					//Batch_UseStats 
					
				: (asBull{$i}="X") & (aCustName{$i}="Usage Statistics")  //Access Violations
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					Batch_AccessViolations
					
				: (asBull{$i}="X") & (aCustName{$i}="Shipped Without Staging")  // Added by: Mark Zinke (12/18/13) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					FG_ShippedWithoutStaging($batch_run_date)
					
				: (asBull{$i}="X") & (aCustName{$i}="Unfavorable Variance")  // Added by: Mark Zinke (1/10/14) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					
					//distributionList set inside method since exe on server
					//Execute on server ( procedure ; stack {; name {; param {; param2 ; ... ; paramN}}}{; *} ) -> Function result
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					$yesterday:=Add to date:C393($batch_run_date; 0; 0; -1)
					$pid:=Execute on server:C373("Job_UnfavorableVariance"; <>lMinMemPart; "Unfavorable Variance"; $yesterday; distributionList)  // Modified by: Mel Bohince (2/5/14), yesterday so manual MT entries are picked up 
					If (False:C215)
						Job_UnfavorableVariance
					End if 
					distributionList:=Batch_GetDistributionList("Glue Rate Variance")
					$pid:=Execute on server:C373("JMI_GluerAnalysis"; <>lMinMemPart; "Gluer Analysis"; $yesterday; distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="PnG Min Check")  // Added by: Mark Zinke (2/4/14) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					PnG_InventoryMinimumWarning
					
				: (asBull{$i}="X") & (aCustName{$i}="Sales By State")  // Modified by: Mel Bohince (3/25/14) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					//INV_SalesByState 
					INV_YTD_Billings_Export(Date:C102("01-01-"+String:C10(Year of:C25(Current date:C33))); $batch_run_date; distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="Glue Durations")  // Modified by: Mel Bohince (3/25/14) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList("Glue Durations")
					$yesterday:=Add to date:C393($batch_run_date; 0; 0; -1)
					$pid:=Execute on server:C373("JMI_setGlueDuration"; <>lMinMemPart; "Gluer Durations"; distributionList)
					If (False:C215)
						JMI_setGlueDuration
					End if 
					
				: (asBull{$i}="X") & (aCustName{$i}="Print Goal")  // Modified by: Mel Bohince (5/8/14) 
					//MESSAGE("   "+aCustName{$i}+<>CR)
					//distributionList:=Batch_GetDistributionList (aCustName{$i})
					//PS_PrintGoal 
					
				: (asBull{$i}="X") & (aCustName{$i}="RM Transaction Export")  // Modified by: Mel Bohince (7/12/17) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					C_DATE:C307($dDateBegin; $dDateEnd)
					$dDateBegin:=UtilGetDate($batch_run_date; "ThisMonth"; ->$dDateEnd)
					RM_TransactionExport($dDateBegin; $dDateEnd; distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="Sales By SalesRep")  // Modified by: Mel Bohince (10/2/17) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					//INV_SalesBySalesRep ("init";distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="YTD Shipments")  // Modified by: Mel Bohince (10/2/17) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					distributionList:=Batch_GetDistributionList(aCustName{$i})
					REL_YTD_Shipments("init"; distributionList)
					
				: (asBull{$i}="X") & (aCustName{$i}="PnG Inventory")  // Modified by: Mel Bohince (8/27/20) 
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					PnG_InventoryCSV
					
				: (asBull{$i}="X") & (aCustName{$i}="ELC Inventory")  // Modified by: Mel Bohince (9/4/20)  
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					ELC_InventoryCSV  // Modified by: Mel Bohince (9/3/20) 
					
					//: (asBull{$i}="X") & (aCustName{$i}="Backup To Dropbox")  // Modified by: Mel Bohince (6/29/21) 
					//MESSAGE("   "+aCustName{$i}+<>CR)
					//util_BackupToDropBox_EOS 
				: (asBull{$i}="X") & (aCustName{$i}="Jobs Missing Board")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					Job_MissingBoard()
					
				: (asBull{$i}="X") & (aCustName{$i}="Setup for next Batch")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					C_TEXT:C284($body; $preheader)
					$body:="Batches appear to have completed normally."+"<br><br>View on 192.168.1.56 ."
					$preheader:=TS2iso
					$distributionList:="garri.ogata@arkay.com,"  // Modified by: Mel Bohince (8/31/21) corrected
					Email_html_body("Batch Completed"; $preheader; $body; 500; $distributionList)  // added by: Mel Bohince (8/30/21)  
					
				: (asBull{$i}="X") & (aCustName{$i}="Log Off aMs Server")
					MESSAGE:C88("   "+aCustName{$i}+<>CR)
					//xText:=ftp_service 
					//QM_Sender (aCustName{$i};"";xText)
					Quit4D
					
			End case 
			
			If (asBull{$i}="X")  //log it
				asBull{$i}:="-"
				$numBatches:=$numBatches-1
				utl_Logfile("BatchRunner.Log"; "END   "+aCustName{$i})
				FLUSH CACHE:C297
				DELAY PROCESS:C323(Current process:C322; 15*60)  //so sync log can see gap
			End if 
			
		End for 
		
		ON ERR CALL:C155("")
		
		//Do some house keeping
		READ WRITE:C146([x_email_logs:101])
		QUERY:C277([x_email_logs:101]; [x_email_logs:101]ReceivedDate:1<($batch_run_date-7))
		If (Records in selection:C76([x_email_logs:101])>0)
			util_DeleteSelection(->[x_email_logs:101])
		End if 
		REDUCE SELECTION:C351([x_email_logs:101]; 0)
		
		util_UnloadAllTables  // Added by: Mel Bohince (1/17/20) 
		
		zCursorMgr("restore")
		If (batchErr=0)
			zwStatusMsg("BATCH RUNNER"; "Finished at "+TS2String(TSTimeStamp))
		Else 
			zwStatusMsg("BATCH RUNNER"; "Finished at "+TS2String(TSTimeStamp)+" ERROR: "+String:C10(batchErr)+" OCCURED")
		End if 
		batchErr:=0
		BEEP:C151
		BEEP:C151
		
		delayUntilDate:=$batch_run_date+1
		delayUntil:=TSTimeStamp(delayUntilDate; delayUntilTime)
	End if   //run was OK'd
	
Until (<>delayCanceled) | (OK=0)
CLOSE WINDOW:C154($winRef)
uWinListCleanup