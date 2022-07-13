//%attributes = {"publishedWeb":true}
//PM: Job_revisionNoticeSend(jobform) -> 
//@author mlb - 8/1/02  14:47
//see JOB_getFormBudget and Job_InkNotification

C_TEXT:C284($1)

distributionList:=""

READ ONLY:C145([Job_Forms_Revision_Notification:119])
QUERY:C277([Job_Forms_Revision_Notification:119]; [Job_Forms_Revision_Notification:119]jobform:1=$1)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	While (Not:C34(End selection:C36([Job_Forms_Revision_Notification:119])))
		distributionList:=distributionList+[Job_Forms_Revision_Notification:119]emailAddress:2+<>TB
		NEXT RECORD:C51([Job_Forms_Revision_Notification:119])
	End while 
	
Else 
	
	ARRAY TEXT:C222($_emailAddress; 0)
	
	SELECTION TO ARRAY:C260([Job_Forms_Revision_Notification:119]emailAddress:2; $_emailAddress)
	
	For ($Iter; 1; Size of array:C274($_emailAddress); 1)
		
		distributionList:=distributionList+$_emailAddress{$Iter}+<>TB
		
	End for 
	
End if   // END 4D Professional Services : January 2019 query selection

REDUCE SELECTION:C351([Job_Forms_Revision_Notification:119]; 0)

If (Length:C16(distributionList)>0)
	EMAIL_Sender("Job Revision Notice "+$1; ""; "a revision has been made"; distributionList)
End if 