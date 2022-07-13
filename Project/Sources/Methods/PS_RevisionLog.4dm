//%attributes = {"publishedWeb":true}
//PM: PS_RevisionLog() -> 
//@author mlb - 6/18/02  15:40
// Modified by: Mel Bohince (3/29/18) add custname incase this was a merged customer job

C_TEXT:C284($jobSeq; $1; $custName; $2)

C_REAL:C285($hrs)
C_TIME:C306($time)

READ WRITE:C146([ProductionSchedules_Revisions:118])
READ WRITE:C146([ProductionSchedules:110])

$jobSeq:=$1  //+"."+String($2;"000")
$chg:=""
$custName:=$2

QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$jobSeq)
If (Records in selection:C76([ProductionSchedules:110])=1)
	If (fLockNLoad(->[ProductionSchedules:110]))
		[ProductionSchedules:110]Customer:11:=$custName
		[ProductionSchedules:110]Planned_MR:52:=[Job_Forms_Machines:43]Planned_MR_Hrs:15
		[ProductionSchedules:110]Planned_Run:53:=[Job_Forms_Machines:43]Planned_RunHrs:37
		[ProductionSchedules:110]Planned_RunRate:54:=[Job_Forms_Machines:43]Planned_RunRate:36
		[ProductionSchedules:110]Info:13:=String:C10(Round:C94([Job_Forms_Machines:43]Planned_MR_Hrs:15; 0))+"+"+String:C10(Round:C94([Job_Forms_Machines:43]Planned_RunHrs:37; 0))  //+" Stk="+[JobMasterLog]S_Number      
		
		//calc total duration
		$hrs:=0
		If ([ProductionSchedules:110]Planned_MR:52>0)
			$hrs:=$hrs+[ProductionSchedules:110]Planned_MR:52
		End if 
		If ([ProductionSchedules:110]Planned_Run:53>0)
			$hrs:=$hrs+[ProductionSchedules:110]Planned_Run:53
		End if 
		$time:=Time:C179(Time string:C180(($hrs*3600)))
		If ([ProductionSchedules:110]DurationSeconds:9#$time)
			[ProductionSchedules:110]Comment:22:="®Revised "+TS2String(TSTimeStamp)+" duration was "+String:C10([ProductionSchedules:110]DurationSeconds:9; HH MM SS:K7:1)+Char:C90(13)+"Old comment: "+[ProductionSchedules:110]Comment:22
			//$chg:=$chg+"new hrs="+String($time;HH MM SS )
			[ProductionSchedules:110]DurationSeconds:9:=$time
		End if 
		
		If ([ProductionSchedules:110]Planned_QtyGood:56#[Job_Forms_Machines:43]Planned_Qty:10)
			[ProductionSchedules:110]Comment:22:="®Revised "+TS2String(TSTimeStamp)+" net good was "+String:C10([ProductionSchedules:110]Planned_QtyGood:56)+Char:C90(13)+"Old comment: "+[ProductionSchedules:110]Comment:22
			//$chg:=$chg+"new qty="+String([Job_Forms_Machines]Planned_Qty)
		End if 
		
		[ProductionSchedules:110]Planned_QtyGood:56:=[Job_Forms_Machines:43]Planned_Qty:10
		[ProductionSchedules:110]Planned_QtyWaste:55:=[Job_Forms_Machines:43]Planned_Waste:11
		
		PS_setJobInfo($jobSeq; [Job_Forms_Machines:43]Flex_field1:6)  // Modified by: Mel Bohince (3/11/16) protect JFM selection
		
		CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "jobItems")  //• Mel - 5/28/03  12:58
		$numSF:=JMI_getNumSubforms(Substring:C12($jobSeq; 1; 8))
		USE NAMED SELECTION:C332("jobItems")
		If ($numSF#[ProductionSchedules:110]NumSubForms:16)
			[ProductionSchedules:110]NumSubForms:16:=$numSF
		End if 
		
		SAVE RECORD:C53([ProductionSchedules:110])
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
			
			UNLOAD RECORD:C212([ProductionSchedules:110])
			REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
			
		Else 
			
			REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
			
		End if   // END 4D Professional Services : January 2019 
		
	Else   //locked, send frank an email so he refreshes later
		$distributionList:=Batch_GetDistributionList("PS_RevisionLog"; "PROD")
		$body:="Jobform "+Substring:C12($jobSeq; 1; 8)+" was revised. Unable to update sequence "+$jobSeq+" on the "+[ProductionSchedules:110]CostCenter:1+" schedule. Please refresh from JML later."
		EMAIL_Sender("Locked Schedule Record"; ""; $body; $distributionList)
	End if   //locked
	
End if 