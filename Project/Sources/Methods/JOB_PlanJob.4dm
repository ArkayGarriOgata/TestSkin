//%attributes = {"publishedWeb":true}
//PM:  JOB_PlanJob  110899  mlb
//formerly `doPlanJob()   -Impact   9/18/93 see also doReviseJob
//mod 3/2/94 `mod 5/18/94 upr 61 `mod 5/23/94 upr 60
//upr 1325  11/23/94 `UPR 1368 12/16/94
//upr 1406 1/19/95 change EstCost_M calc to want qty
//1/26/95 set up jobmasterlog record` drop the field upr 1449 3/10/95
//upr 1460 3/21/95 `5/3/95 upr 1489 chip
//•5.10.95 add effectivity date to mach job
//•080495  MLB  UPR 1695 job tracking
//•082295  MLB  UPR 1702 outside service
//• 1/9/97 - cs - modification to allow multiple jobs on one form
//• 2/27/97 cs problem with creating a job, attempt to create dupicate FG
//clear selections
//• 5/23/97 cs upr 1870 `• 3/4/98 cs add Caliper to form level
//•110899  mlb  UPR switch to formcarton cost instead of cspec cost
//080700 add control number
//• mlb - 9/11/02  12:13 add comparison to order est w/ JOB_CompareToEstimate
//*Create Context
//dialogTitle:="Creating Job "+String([Estimates]JobNo)

C_DATE:C307($pressDate; $madDate)
C_TEXT:C284($comment)
C_LONGINT:C283($0; $3; $i; $numRecs; $jobId)
C_TEXT:C284($1; $4; $5; $diff)
C_TEXT:C284($2)

$winRef:=OpenSheetWindow(->[Jobs:15]; "ReviseJob_Dialog")
GOTO XY:C161(2; 2)
MESSAGE:C88(Char:C90(13)+" Opening Job...")
$pressDate:=!00-00-00!
$madDate:=!00-00-00!
$comment:=""
JOB_setReadWrite

//*Work with the JOB header
CREATE RECORD:C68([Jobs:15])
$jobId:=Job_setJobNumber
$0:=$jobId
[Jobs:15]JobNo:1:=$jobId
[Jobs:15]CustID:2:=$1
If ([Customers:16]ID:1#$1)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=$1)
End if 
[Jobs:15]CustomerName:5:=[Customers:16]Name:2
[Jobs:15]Line:3:=$2
[Jobs:15]Status:4:="Planned"
[Jobs:15]EstimateNo:6:=$4  //0-1234.12
[Jobs:15]CaseScenario:7:=$5  //AA
[Jobs:15]OrderNo:15:=[Estimates:17]OrderNo:51  //12/21/94
$diff:=[Jobs:15]EstimateNo:6+[Jobs:15]CaseScenario:7  //0-1234.12AA
QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$diff)
If (Records in selection:C76([Estimates_Differentials:38])>0)
	[Jobs:15]ProcessSpec:14:=[Estimates_Differentials:38]ProcessSpec:5
	[Jobs:15]Pld_CostTtlLabo:12:=[Estimates_Differentials:38]CostTtlLabor:11
	[Jobs:15]Pld_CostTtlOH:13:=[Estimates_Differentials:38]CostTtlOH:12
	[Jobs:15]Pld_CostTtlMatl:11:=[Estimates_Differentials:38]CostTtlMatl:13
End if 
[Jobs:15]ModDate:8:=4D_Current_date
[Jobs:15]ModWho:9:=<>zResp
[Jobs:15]zCount:10:=1
C_TEXT:C284(<>pjtId)
[Jobs:15]ProjectNumber:18:=Pjt_getReferId  //•5/04/00  mlb  
If (Length:C16([Jobs:15]ProjectNumber:18)=0)
	[Jobs:15]ProjectNumber:18:=[Estimates:17]ProjectNumber:63
End if 
pjtId:=[Jobs:15]ProjectNumber:18
SAVE RECORD:C53([Jobs:15])

[Estimates:17]JobNo:50:=$jobId
[Estimates:17]Status:30:="Budget"
util_ComboBoxSetup(->astat; [Estimates:17]Status:30)
SAVE RECORD:C53([Estimates:17])

//• mlb - 10/25/02  14:34 change stat from new
PSPEC_SetStatus(([Jobs:15]CustID:2+":"+[Jobs:15]ProcessSpec:14); "Final")
//*      make estimate family share common job#
[Estimates:17]JobNo:50:=$jobId
SAVE RECORD:C53([Estimates:17])
C_LONGINT:C283(<>JobNo; $id)
<>EstNo:=[Estimates:17]EstimateNo:1
<>JobNo:=$jobId
$id:=New process:C317("EST_ChgJobRefer"; <>lMinMemPart; "Estimate Job Change")
If (False:C215)
	EST_ChgJobRefer
End if 

//utl_LogfileServer (<>zResp;"JOB NEW--"+String($jobId))


//*Work with the Jobforms
//*    retain old form info
QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=(String:C10($jobId)+".**"))  //upr 1460 3/21/95
If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
	$pressDate:=[Job_Forms_Master_Schedule:67]PressDate:25
	$madDate:=[Job_Forms_Master_Schedule:67]MAD:21
	$comment:=[Job_Forms_Master_Schedule:67]Comment:22
	DELETE SELECTION:C66([Job_Forms_Master_Schedule:67])
End if 

zwStatusMsg("JOB"; "Planning Job Forms...")
QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=$diff)
$numRecs:=Records in selection:C76([Estimates_DifferentialsForms:47])
If ($numRecs>0)
	JOB_getItemAccumulations(0)
	JOB_getItemAccumulations($numRecs)
	
	For ($i; 1; $numRecs)
		JOB_getFormBudget($jobId; [Jobs:15]EstimateNo:6; "Planned")
		JOB_getItemAccumulations($i; [Job_Forms:42]JobFormID:5; Record number:C243([Job_Forms:42]); [Estimates_DifferentialsForms:47]NumberUpOverrid:30)
		// Modified by: Mel Bohince (10/2/18) add version zero date to arg so earliestStart_printflow can be populated
		JML_newViaJob([Job_Forms:42]JobFormID:5; $pressDate; $madDate; $comment; [Estimates:17]Sales_Rep:13; [Jobs:15]Line:3; Substring:C12([Estimates:17]EstimateNo:1; 1; 6); [Job_Forms:42]Run_Location:55; [Job_Forms:42]VersionZeroDate:89)
		NEXT RECORD:C51([Estimates_DifferentialsForms:47])
	End for 
	//*Work with the Job opertions
	MESSAGE:C88(Char:C90(13)+"          Operations...")
	JOB_getMachineBudget($jobId; $diff)
	
	//*Work with the Job materials  
	MESSAGE:C88(Char:C90(13)+"          Materials...")
	JOB_getMaterialBudget($jobId; $diff)
	
	//*Work with the Job items
	MESSAGE:C88(Char:C90(13)+"          Items...")
	JOB_getItemBudget($jobId; $diff)
	
	//*Apply item totals back to the form  
	MESSAGE:C88(Char:C90(13)+"          Setting totals...")
	JOB_getItemAccumulations
	
	JOB_CompareToEstimate($diff)  //• mlb - 9/11/02  12:13
Else 
	BEEP:C151
	ALERT:C41("Could find and forms on the differential")
End if 

pattern_PassThru(->[Jobs:15])
JOB_reduceSelection
ViewSetter(2; ->[Jobs:15])

JOB_CompareToEstimate($diff)
//*Clean up
CLOSE WINDOW:C154
JOB_reduceSelection
JOB_getItemAccumulations(0)