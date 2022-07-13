//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/16/07, 18:02:15
// ----------------------------------------------------
// Method: trigger_JobCloseSummary
// ----------------------------------------------------

Case of 
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Job_Forms_CloseoutSummaries:87]TotStdVar:11:=NaNtoZero([Job_Forms_CloseoutSummaries:87]TotStdVar:11)
		
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		[Job_Forms_CloseoutSummaries:87]TotStdVar:11:=NaNtoZero([Job_Forms_CloseoutSummaries:87]TotStdVar:11)
		
End case 