//%attributes = {"publishedWeb":true}
//PM: Job_revisionNoticeSet(jobform;email) -> 
//@author mlb - 8/1/02  14:22

C_TEXT:C284($1)
C_TEXT:C284($2)

If (Length:C16($1)=8) & (Length:C16($2)>10)
	QUERY:C277([Job_Forms_Revision_Notification:119]; [Job_Forms_Revision_Notification:119]jobform:1=$1; *)
	QUERY:C277([Job_Forms_Revision_Notification:119];  & ; [Job_Forms_Revision_Notification:119]emailAddress:2=$2)
	If (Records in selection:C76([Job_Forms_Revision_Notification:119])=0)
		CREATE RECORD:C68([Job_Forms_Revision_Notification:119])
		[Job_Forms_Revision_Notification:119]jobform:1:=$1
		[Job_Forms_Revision_Notification:119]emailAddress:2:=$2
		[Job_Forms_Revision_Notification:119]tsTimeStamp:3:=TSTimeStamp
		SAVE RECORD:C53([Job_Forms_Revision_Notification:119])
		zwStatusMsg("REV NOTICE"; "You will be notified of revisions to jobform "+$1)
	Else 
		BEEP:C151
		zwStatusMsg("REV NOTICE"; "You are already subscribed to this jobform")
	End if 
	REDUCE SELECTION:C351([Job_Forms_Revision_Notification:119]; 0)
Else 
	BEEP:C151
	zwStatusMsg("ERROR"; "Jobform and Email address required for notification")
End if 