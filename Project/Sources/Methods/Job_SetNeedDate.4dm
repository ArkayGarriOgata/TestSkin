//%attributes = {}
// Method: Job_SetNeedDate () -> 
// ----------------------------------------------------
// by: mel: 12/10/03, 12:59:31
// ----------------------------------------------------
// Updates:
// • mel (10/25/04, 15:48:41) only set if it is blank
// ----------------------------------------------------

MESSAGES OFF:C175
READ WRITE:C146([Job_Forms:42])
QUERY:C277([Job_Forms:42]; [Job_Forms:42]NeedDate:1=!00-00-00!; *)
//QUERY([JobForm]; | ;[JobForm]NeedDate<4D_Current_date;*)
QUERY:C277([Job_Forms:42];  & ; [Job_Forms:42]Completed:18=!00-00-00!)

If (Records in selection:C76([Job_Forms:42])>0)
	APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]NeedDate:1:=JML_get1stRelease([Job_Forms:42]JobFormID:5))
End if 

REDUCE SELECTION:C351([Job_Forms:42]; 0)