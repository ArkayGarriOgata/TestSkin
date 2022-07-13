//%attributes = {"publishedWeb":true}
//(p) JCOCalcNPrint
//calc actuals, allocations and print closeout report
//created so that multiple areas of DoJobCloseout can access
//• 6/9/98 cs created
//• 7/9/98 cs added & updated a closing marker for JMI records
//• 8/5/98 cs sometimes jobform is NOT getting closed

aJobNo:=[Job_Forms:42]JobFormID:5  //setup for closeout repor

USE SET:C118("Materials")

JOB_RollupActuals
C_BOOLEAN:C305(isClosing)
isClosing:=True:C214
SAVE RECORD:C53([Job_Forms:42])  //• 8/5/98 cs just in case

CREATE SET:C116([Job_Forms:42]; "JobHold")
JOB_AllocateActual
JCOCloseInkPO

USE SET:C118("JobHold")  //• 8/5/98 cs 

JCOCloseForm
JOB_Closeout("S")
If (Count parameters:C259=0)
	JCOCloseJobForm  //this procedure checks whether all Job forms are closed   
End if 