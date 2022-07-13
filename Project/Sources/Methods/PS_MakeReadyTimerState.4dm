//%attributes = {"publishedWeb":true}
//PS_MakeReadyTimerState(->running;->tStart;->iLimit;->sJobSeq)

C_TIME:C306(tStart)
C_LONGINT:C283(iLimit)
C_BOOLEAN:C305(running)
C_TEXT:C284(sJobSeq)
C_POINTER:C301($1; $2; $3; $4; $runningPtr; $startPtr; $limitPtr; $jobPtr)

If (<>pidTimer#0)
	GET PROCESS VARIABLE:C371(<>pidTimer; running; $runningPtr->; tStart; $startPtr->; iLimit; $limitPtr->; sJobSeq; $jobPtr->)
End if 