//%attributes = {"publishedWeb":true}
//PM:  JOB_ReviseFindDiffESTIMATE]EstimateNo;->sState)  2/27/01  mlb
//load diff and its forms

C_TEXT:C284($1; $Diff)
C_POINTER:C301($2)
C_TEXT:C284($0)

$Diff:=$1+$2->
QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$diff)
If (Records in selection:C76([Estimates_Differentials:38])=1)
	$0:=[Estimates_Differentials:38]PSpec_Qty_TAG:25
	QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=$diff)
	If (Records in selection:C76([Estimates_DifferentialsForms:47])=0)
		BEEP:C151
		ALERT:C41("Differential '"+$2->+"' has no forms"+", try again or Cancel.")
		$2->:=""
		$0:=""
		REDUCE SELECTION:C351([Estimates_DifferentialsForms:47]; 0)
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Differential '"+$2->+"' was not found for estimate "+[Estimates:17]EstimateNo:1+", try again or Cancel.")
	$2->:=""
	$0:=""
	REDUCE SELECTION:C351([Estimates_Differentials:38]; 0)
End if 