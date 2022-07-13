//%attributes = {"publishedWeb":true}
//(P)JOB_Closeout
//formerly  rNewCloseout : Produces NEWJob Closeout Report
//based on mRptCloseout2
// adds a batch feature to the previous procedure to batch load jobs
//the Close-out reports are  produced as a group
//$1 string 2 - Flag to determine type of report to print 'F' form, 'J' Job, 
//  'S' Single form (from Modify Actuals screen)
//• 12/15/97 cs created
//•090498  MLB  don't change the readwrite state
//•112398  MLB  UPR HTK's third Page
//051499 mlb set state to closed when batching
//102299 mlb make batch close more like individual close
//•1/25/00  mlb  enhance 3rd page
//•072102  mlb addedJIC_CloseOutRegen ("closedJMIs")  

C_TEXT:C284($1)
C_BOOLEAN:C305($PrintForm; isClosing)
READ ONLY:C145([ProductionSchedules:110])
MESSAGES OFF:C175
util_PAGE_SETUP(->[Job_Forms:42]; "NewJCORpt.h")
READ WRITE:C146([Job_Forms:42])
READ WRITE:C146([Job_Forms_CloseoutSummaries:87])
ON EVENT CALL:C190("eCancelPrint")
<>fContinue:=True:C214
utl_Trace
JCOInitVars
isClosing:=True:C214
Case of 
	: ($1="F") | ($1="R")  //via Report popup
		DIALOG:C40([Job_Forms:42]; "GroupClose")
		//cbPrint set on dialog
		sFormTitle:="Job FORM Closeout"
		
	: ($1="S")  //Single form via Closeout button on InputActual2
		$PrintForm:=True:C214
		ARRAY TEXT:C222(aRpt; 1)
		ARRAY TEXT:C222(aJFID; 1)
		aRpt{1}:="√"
		aJFID{1}:=aJobNo
		sFormTitle:="Job FORM Closeout"
		OK:=1
		cbPrint:=1
		
		//: ($1="J")  `OBSOLETE close entire job after an S or F
		//$PrintForm:=False
		//ARRAY TEXT(aRpt;1)
		//ARRAY TEXT(aJFID;1)
		//aRpt{1}:="√"
		//aJFID{1}:=aJobNo
		//OK:=1
		//cbPrint:=1
		//sFormTitle:="COMPLETE Job Closeout"
		
	Else 
		OK:=0
		cbPrint:=0
End case 

If (OK=1)
	CREATE EMPTY SET:C140([Job_Forms_Items:44]; "closedJMIs")  //•072102  mlb candidates for FIFO Regen
	For ($i; 1; Size of array:C274(aRpt))  //*for each job, print jobclosout,waste and save jobclosesummary record.
		If (aRpt{$i}="√")  //selected to be reported
			zwStatusMsg("Close Out"; " Print close out for "+aJFID{$i})
			
			iPage:=1
			iPixel:=0
			zzi:=0
			fHdgChg:=False:C215
			fBold:=False:C215
			PDF_setUp("jobcloseout"+aJFID{$i}+".pdf")
			
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=aJFID{$i})
			RELATE MANY:C262([Job_Forms:42]JobFormID:5)  //get [JobMakesItem]'s    
			CREATE SET:C116([Job_Forms_Items:44]; "thisJobJMIs")  //•072102  mlb candidates for FIFO Regen
			UNION:C120("closedJMIs"; "thisJobJMIs"; "closedJMIs")  //•072102  mlb candidates for FIFO Regen
			CLEAR SET:C117("thisJobJMIs")
			RELATE ONE:C42([Job_Forms:42])  // get the job header
			Case of 
				: ($1="F")  //051499 mlb set state to closed when batching
					utl_Trace
					//102299 mlb make batch close more like individual close start
					CREATE SET:C116([Job_Forms_Materials:55]; "Materials")  //create sets so that record can be returned
					CREATE SET:C116([Job_Forms_Items:44]; "Production")
					CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "MachTickets")
					QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Location:15="WIP")
					If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
						ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Sequence:13; >; [Raw_Materials_Transactions:23]Commodity_Key:22; >)
					End if 
					CREATE SET:C116([Raw_Materials_Transactions:23]; "RmXfers")
					CREATE SET:C116([Finished_Goods_Transactions:33]; "FGXfers")
					CREATE SET:C116([Jobs:15]; "Jobs")
					QUERY SELECTION:C341([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Actual_Qty:14=0)
					CREATE SET:C116([Job_Forms_Materials:55]; "NotIssued")
					USE SET:C118("Materials")
					aJobNo:=[Job_Forms:42]JobFormID:5  //setup for closeout repor
					$numAlloc:=RM_AllocationRemove(aJobNo)
					
					USE SET:C118("Materials")
					JOB_RollupActuals
					SAVE RECORD:C53([Job_Forms:42])  //• 8/5/98 cs just in case
					CREATE SET:C116([Job_Forms:42]; "JobHold")
					JOB_AllocateActual
					JCOCloseInkPO
					USE SET:C118("JobHold")  //• 8/5/98 cs  
					CLEAR SET:C117("NotIssued")
					CLEAR SET:C117("Materials")
					CLEAR SET:C117("Production")
					CLEAR SET:C117("MachTickets")
					CLEAR SET:C117("RmXfers")
					CLEAR SET:C117("MonthSum")
					CLEAR SET:C117("FGXfers")
					CLEAR SET:C117("Jobs")
					//102299 mlb make batch close more like individual close end         
					JCOCloseForm
					
					//: ($1="R")
					//CREATE EMPTY SET([Job_Forms_Items];"closedJMIs")
					//If ([Job_Forms]ClosedDate=!00/00/00!)
					//$PrintForm:=False
					//BEEP
					//ALERT([Job_Forms]JobFormID+" is not closed, can't print it.")
					//Else 
					//$PrintForm:=True
					//End if 
			End case 
			
			//Else   `printing an entire job
			//QUERY([Job_Forms];[Job_Forms]JobNo=aJFID{$i})
			//uRelateSelect (->[Job_Forms_Items]JobForm;->[Job_Forms]JobFormID;0)  `get JMIs for these Jobforms
			//FIRST RECORD([Job_Forms])
			
			If (JCOBuildHead($PrintForm))  //if the header can be built (there is an actual production qty)
				JCORptCreateArr
				
				If (<>Roanoke_CCs="")  //this routine has not yet been run, do so
					uSetupCCDivisio  //setup text of CCs for each division
				End if 
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
					
					CREATE EMPTY SET:C140([Cost_Centers:27]; "Effective")
					UNION:C120("◊CCRoanoke"; "◊CCHauppauge"; "Effective")  //gather all effective CCs into one place
					
				Else 
					
					UNION:C120("◊CCRoanoke"; "◊CCHauppauge"; "Effective")
					
				End if   // END 4D Professional Services : January 2019 
				
				USE SET:C118("Effective")
				
				If (JCOBuildA)  //* build arrays for printing, assumes all related Jobform & JMI records in hand
					JCOBuildB_C  //* handles either one form or entire Job
					JCOBuildD_E
					
					If (cbPrint=1)  //printing a form
						Print form:C5([Job_Forms:42]; "NewJCORpt.h")
						iPixel:=120  //12/30/94
					End if 
					rSV:=ayE2{23}  //board spending & waste varience
					rWV:=ayE2{21}
					
					If (cbPrint=1)  //printing a form
						Print form:C5([Job_Forms:42]; "CloseoutRept_BV")
						iPixel:=34
					End if 
					gPrintA("*")
					gPrintB_C("*")
					gPrintD_E("*")
					If (cbPrint=1)  //printing a form
						PAGE BREAK:C6  //(>)
					End if 
					
					If (cbPrint=1)  //printing a form
						JobCloseOut3rdPage  //•1/25/00  mlb  enhance 3rd page
						util_PAGE_SETUP(->[Job_Forms:42]; "NewJCORpt.h")  //•2/23/00  mlb 
					End if 
					
					doNewJCloseRec  //032696 TJF this saves a jobclosesummary record
					
					If (<>fContinue=False:C215)
						$i:=Size of array:C274(aRpt)  //get out of loop
					End if 
					
				Else   //can not print because of production qty
					//$i:=Size of array(aRpt)+1
					//ALERT("The is NO actual production for the job."+Char(13)+"Printing canceled.")
				End if   //jcobuildhead
				gClearArrays
			End if 
		End if 
	End for 
	//$i:=util_SetSaver ("save";Table(->[Job_Forms_Items]);"closedJMIs")
	//JIC_CloseOutRegen ("closedJMIs")  `•072102  mlb  
	CLEAR SET:C117("closedJMIs")
	CLOSE WINDOW:C154
End if 


MESSAGES ON:C181
ON EVENT CALL:C190("")