//%attributes = {"publishedWeb":true}
//PM: Job_revisionNoticeClear(jobform) -> 
//@author mlb - 8/1/02  14:39

C_TEXT:C284($1)
C_LONGINT:C283($err)

READ WRITE:C146([Job_Forms_Revision_Notification:119])
QUERY:C277([Job_Forms_Revision_Notification:119]; [Job_Forms_Revision_Notification:119]jobform:1=$1)
If (Records in selection:C76([Job_Forms_Revision_Notification:119])>0)
	$err:=util_DeleteSelection(->[Job_Forms_Revision_Notification:119])
End if 