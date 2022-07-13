//%attributes = {"publishedWeb":true}
//PM: Job_InkNotification() -> 
//@author mlb - 7/31/02  14:55
//send email to ink guy if WIP job is down graded or
//if revision is to something on the schedule that has ink made
//see JOB_getFormBudget and Job_revisionNoticeSend

If (Length:C16($1)>=5)
	$jobSeq:=$1+"@"
	READ ONLY:C145([ProductionSchedules:110])
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$jobSeq)
	If (Records in selection:C76([ProductionSchedules:110])>0)
		C_LONGINT:C283($jml)
		SET QUERY DESTINATION:C396(Into variable:K19:4; $jml)
		QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]Printed:32=!00-00-00!; *)
		QUERY:C277([Job_Forms_Master_Schedule:67];  & ; [Job_Forms_Master_Schedule:67]DateComplete:15=!00-00-00!)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		If ($jml>0)
			QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]InkReady:20#!00-00-00!)
			If (Records in selection:C76([ProductionSchedules:110])>0)
				t1:="WARNING, this job has been marked 'Ink Ready'."
			Else 
				t1:="Be advised if you have already reviewed this job"
			End if 
			EMAIL_Sender("Job Form Revised "+$1; ""; t1; "roanoke.inkroom@arkay.com")
		End if 
		REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	End if 
End if 