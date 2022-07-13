//%attributes = {"publishedWeb":true}
//PM: PS_getJobSeqFromEstimate(estimate#) -> jobSeq
//@author mlb - 5/20/02  10:06

C_TEXT:C284($jobSeq; $0; $1; $estimate)

$estimate:=$1
READ WRITE:C146([Estimates:17])
QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$estimate)
$numEsts:=Records in selection:C76([Estimates:17])
Case of 
	: ($numEsts=1) & (fLockNLoad(->[Estimates:17]))
		$makeJob:=False:C215
		$job:=[Estimates:17]JobNo:50
		
		If ($job=0)
			$makeJob:=True:C214
		Else 
			QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=$job)
			If (Records in selection:C76([Jobs:15])=0) | ([Jobs:15]Status:4="Reserved")
				$makeJob:=True:C214
			End if 
		End if 
		If ($makeJob)
			<>Est2Zoom:=$estimate
			<>iMode:=3
			JOB_NewJob
			QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$estimate)
			$job:=[Estimates:17]JobNo:50
		End if 
		
		$jobSeq:=PS_pickSequence($job)
		
	: ($numEsts>1)
		BEEP:C151
		zwStatusMsg("JOB via EST"; "More than 1 estimate found with "+$estimate)
		$jobSeq:=$estimate
	Else 
		BEEP:C151
		zwStatusMsg("JOB via EST"; "No estimates found with "+$estimate)
		$jobSeq:=$estimate
End case 
REDUCE SELECTION:C351([Estimates:17]; 0)
REDUCE SELECTION:C351([Jobs:15]; 0)
REDUCE SELECTION:C351([Job_Forms:42]; 0)
REDUCE SELECTION:C351([Estimates:17]; 0)
$0:=$jobSeq