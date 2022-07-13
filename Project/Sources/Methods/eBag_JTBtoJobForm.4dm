//%attributes = {"publishedWeb":true}
//PM: eBag_JTBtoJobForm(jtb#) -> jobformid
//@author mlb - 5/30/02  13:06

C_TEXT:C284($1; $0)

QUERY:C277([JTB_Job_Transfer_Bags:112]; [JTB_Job_Transfer_Bags:112]ID:1=$1)
If (Records in selection:C76([JTB_Job_Transfer_Bags:112])=1)
	If (Length:C16([JTB_Job_Transfer_Bags:112]Jobform:3)=8)
		$0:=[JTB_Job_Transfer_Bags:112]Jobform:3
	Else 
		BEEP:C151
		ALERT:C41("Job Transfer Bag "+$1+" was not assigned a jobform")
		$0:=""
	End if 
Else 
	BEEP:C151
	ALERT:C41("Job Transfer Bag "+$1+" was not found")
	$0:=""
End if 
REDUCE SELECTION:C351([JTB_Job_Transfer_Bags:112]; 0)