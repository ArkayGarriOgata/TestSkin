//%attributes = {"publishedWeb":true}
//PM:  JOB_ReviseExisting2  110899  mlb
//formerly  `doReviseJob2 `based on doReviseJob `see also JOB_PlanJob
//• 7/17/98 cs stop system from revising closed forms/jobs
//  this means that we need to create/remove supporting records on a per jobform 
//  basis - not wholesale - this means a rewrite of a major section of this code
//• 8/5/98 cs stop deletion of jobmaster log
//•102798  MLB  UPR 1983 ink POs are not retained, also JMI act and glue date.
//•102898  MLB  retrain a few more things
//•102998  MLB didn't close search
//•111298  MLB  didn't reference the element# when building sort key
//•012899  MLB  UPR 169 revisited, don't del material that have been issued
//•020499  MLB  allow shortcut for Lauder jobs
//•051299  mlb  UPR 1921 remove matl&op duplication, recal acts. for the same
//•052899  mlb  consider form number along with item and subform when retain is do
//• mlb - 10/2/01  allow a form to be removed by taking it off the Differntial
//• mlb - 9/11/02  12:13 add comparison to order est w/ JOB_CompareToEstimate
// Modified by: Mel Bohince (3/29/18) add $custName in case this was a merged customer job
//*Create Context

MESSAGES OFF:C175

//dialogTitle:="Revising Job "+String([Estimates]JobNo)
$winRef:=OpenSheetWindow(->[Jobs:15]; "ReviseJob_Dialog")
//NewWindow (636;438;0;8;"Revising with "+$1+" "+$2)
GOTO XY:C161(2; 2)
MESSAGE:C88(Char:C90(13)+" Finding Job...")

C_DATE:C307($pressDate; $madDate)
C_TEXT:C284($comment; $ClosedForms; $tempJobform)
C_LONGINT:C283($i; $numRecs; iJobId; $hit; $0)
C_TEXT:C284($1; $diff; $CustID; $Estimate; $custName)
C_TEXT:C284(sState)
C_BOOLEAN:C305($continue)

$pressDate:=!00-00-00!
$madDate:=!00-00-00!
$comment:=""
$Estimate:=$1
sState:=$2
$diff:=$Estimate+sState
JOB_setReadWrite
CREATE SET:C116([Estimates_Differentials:38]; "HoldCase")

//*Establish which job and forms are going to be revised
DIALOG:C40([Jobs:15]; "ReviseJob_Dialog")
ERASE WINDOW:C160
If (OK=1) & (Records in selection:C76([Jobs:15])=1)  // If (Records in selection([JOB])=1) & ([JOB]Status#"Closed")  `• 7/17/98 cs stop
	GOTO XY:C161(2; 2)
	MESSAGE:C88(Char:C90(13)+" Revising Job...")
	$0:=iJobId  // job record selected
	[Estimates:17]JobNo:50:=iJobId
	[Estimates:17]Status:30:="Budget"
	util_ComboBoxSetup(->astat; [Estimates:17]Status:30)
	SAVE RECORD:C53([Estimates:17])
	$diff:=$Estimate+sState
	
	//*Work with the JOB header
	If (fLockNLoad(->[Jobs:15]))
		
		//utl_LogfileServer (<>zResp;"JOB REVISED--"+String(iJobId))
		
		
		CREATE SET:C116([Estimates_DifferentialsForms:47]; "CaseForms")
		If ([Jobs:15]Status:4="Reserved")
			[Jobs:15]Status:4:="Planned"
		Else 
			[Jobs:15]Status:4:="Revised"
		End if 
		[Jobs:15]CaseScenario:7:=sState
		// • mel (8/5/04, 11:31:43) change log
		[Jobs:15]ChangeLog:19:=TS2String(TSTimeStamp)+":"+Char:C90(13)+tTitle+Char:C90(13)+"-----"+Char:C90(13)+[Jobs:15]ChangeLog:19
		$Custid:=[Jobs:15]CustID:2
		[Jobs:15]EstimateNo:6:=$Estimate
		[Jobs:15]Line:3:=[Estimates:17]Brand:3
		If ([Estimates:17]Cust_ID:2=<>sCombindID)  //• 4/17/97 cs if this estimate/budget is for a combined customer
			[Jobs:15]CustomerName:5:=<>CombinedCustomerName  //over ride previous job customer name & ID per Lena 4/16/97
			[Jobs:15]CustID:2:=<>sCombindID
		End if 
		$custName:=[Jobs:15]CustomerName:5  // Modified by: Mel Bohince (3/29/18) add custname incase this was a merged customer job
		[Jobs:15]ProcessSpec:14:=[Estimates_Differentials:38]ProcessSpec:5
		[Jobs:15]Pld_CostTtlLabo:12:=[Estimates_Differentials:38]CostTtlLabor:11
		[Jobs:15]Pld_CostTtlOH:13:=[Estimates_Differentials:38]CostTtlOH:12
		[Jobs:15]Pld_CostTtlMatl:11:=[Estimates_Differentials:38]CostTtlMatl:13
		[Jobs:15]ModDate:8:=4D_Current_date
		[Jobs:15]ModWho:9:=<>zResp
		pjtId:=[Estimates:17]ProjectNumber:63  //• mlb - 10/22/02  15:54
		[Jobs:15]ProjectNumber:18:=pjtId
		
		SAVE RECORD:C53([Jobs:15])
		UNLOAD RECORD:C212([Jobs:15])
		READ ONLY:C145([Jobs:15])
		LOAD RECORD:C52([Jobs:15])
		//• mlb - 10/25/02  14:34 change stat from new
		PSPEC_SetStatus(([Jobs:15]CustID:2+":"+[Jobs:15]ProcessSpec:14); "Final")
		
		//*Work with the Jobforms
		For ($i; 1; Size of array:C274(aJFid))
			If (aSelected{$i}="X")  // revise this formjob
				JOB_getItemAccumulations(0)
				JOB_getItemAccumulations(1)
				
				Case of 
					: (aRecNo{$i}>=0)
						USE SET:C118("CaseForms")
						QUERY SELECTION:C341([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffFormId:3=$diff+Substring:C12(aJFid{$i}; 7; 2))
					Else 
						GOTO RECORD:C242([Estimates_DifferentialsForms:47]; (aRecNo{$i}*-1))  //new one
				End case 
				
				MESSAGE:C88(Char:C90(13)+" Revising Job Form#  "+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")+Char:C90(13))
				If (Records in selection:C76([Estimates_DifferentialsForms:47])=1)
					If (aRecNo{$i}>=0)
						GOTO RECORD:C242([Job_Forms:42]; aRecNo{$i})
						JOB_getFormBudget(iJobId; $Estimate; "Revised")
					Else 
						JOB_getFormBudget(iJobId; $Estimate; "Planned")
						aRecNo{$i}:=Record number:C243([Job_Forms:42])
					End if 
					JOB_getItemAccumulations(1; [Job_Forms:42]JobFormID:5; aRecNo{$i}; [Estimates_DifferentialsForms:47]NumberUpOverrid:30)
					
					//*Work with the Job opertions
					MESSAGE:C88(Char:C90(13)+"          Operations..."+Char:C90(13))
					JOB_getMachineBudget(iJobId; [Estimates_DifferentialsForms:47]DiffFormId:3; aJFid{$i})
					
					If ([Customers:16]ID:1#[Jobs:15]CustID:2)
						QUERY:C277([Customers:16]; [Customers:16]ID:1=[Jobs:15]CustID:2)
					End if 
					JML_newViaJob([Job_Forms:42]JobFormID:5; $pressdate; $madDate; $comment; [Customers:16]SalesmanID:3; [Jobs:15]Line:3; Substring:C12($Estimate; 1; 6); [Job_Forms:42]Run_Location:55; [Job_Forms:42]VersionZeroDate:89)
					LOAD RECORD:C52([Job_Forms_Master_Schedule:67])  //• mlb - 7/30/02  15:46
					[Job_Forms_Master_Schedule:67]SheetQty:6:=[Job_Forms:42]EstGrossSheets:27  //• mlb - 10/29/01  13:28
					[Job_Forms_Master_Schedule:67]JobType:31:=[Job_Forms:42]JobType:33
					[Job_Forms_Master_Schedule:67]PlannerReleased:14:=[Job_Forms:42]PlnnerReleased:59
					If ([Job_Forms_Master_Schedule:67]LocationOfMfg:30="")
						[Job_Forms_Master_Schedule:67]LocationOfMfg:30:=[Job_Forms:42]Run_Location:55
					End if 
					[Job_Forms_Master_Schedule:67]Operations:36:=""
					JML_getOperations
					SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
					REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)  //• mlb - 7/30/02  15:46          
					
					//*Work with the Job materials
					MESSAGE:C88(Char:C90(13)+"          Materials..."+Char:C90(13))
					JOB_getMaterialBudget(iJobId; [Estimates_DifferentialsForms:47]DiffFormId:3; aJFid{$i})
					
					//*Work with the Job items
					MESSAGE:C88(Char:C90(13)+"          Items...")
					JOB_getItemBudget(iJobId; [Estimates_DifferentialsForms:47]DiffFormId:3; aJFid{$i})
					
					PS_JobIsRevised(aJFid{$i}; $custName)  // Modified by: Mel Bohince (3/29/18) add custname incase this was a merged customer job 
					
				Else   //• mlb - 10/2/01  11:35
					GOTO RECORD:C242([Job_Forms:42]; aRecNo{$i})
					RELATE MANY:C262([Job_Forms:42]JobFormID:5)
					If (Records in selection:C76([Job_Forms_Machine_Tickets:61])=0) & (Records in selection:C76([Raw_Materials_Transactions:23])=0)
						CONFIRM:C162("Remove form "+aJFid{$i}+" from this job?"; "Remove"; "Keep")
						If (OK=1)
							DELETE SELECTION:C66([Job_Forms_Machines:43])
							DELETE SELECTION:C66([Job_Forms_Materials:55])
							DELETE SELECTION:C66([Job_Forms_Items:44])
							DELETE RECORD:C58([Job_Forms_Master_Schedule:67])
							DELETE RECORD:C58([Job_Forms:42])
							
							//see job 97381, est 5-2407.11
							// Modified by: Mel Bohince (4/1/16) give notice to schedule records
							READ WRITE:C146([ProductionSchedules:110])
							QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=aJFid{$i}+"@")  // Modified by: Mel Bohince (3/31/16) clear out production schedule
							If (Records in selection:C76([ProductionSchedules:110])>0)
								APPLY TO SELECTION:C70([ProductionSchedules:110]; [ProductionSchedules:110]JobInfo:58:="JOB FORM DELETED, CALL PLANNER ["+<>zRESP+"]")
								
								If (Records in set:C195("LockedSet")>0)
									ALERT:C41(String:C10((Records in set:C195("LockedSet")=0))+" Schedule record(s) were locked, notify Frank that form "+aJFid{$i}+" is gone.")
								End if 
								
							End if 
						End if 
					End if 
				End if   //diff form
				
				//*Apply item totals back to the form  
				MESSAGE:C88(Char:C90(13)+"          Setting totals...")
				JOB_getItemAccumulations
			End if   //√
		End for 
		
		pattern_PassThru(->[Jobs:15])
		JOB_reduceSelection
		ViewSetter(2; ->[Jobs:15])
		
		JOB_CompareToEstimate($diff)  //• mlb - 9/11/02  12:13
		
		CREATE SET:C116([Estimates_DifferentialsForms:47]; "CaseForms")
	End if 
End if 

CLOSE WINDOW:C154
CLEAR SET:C117("HoldCase")