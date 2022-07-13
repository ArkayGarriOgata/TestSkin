//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/18/13, 11:33:33
// ----------------------------------------------------
// Method: Est_ShowErrorsForMgr
// ----------------------------------------------------

C_LONGINT:C283($xlWinRef)

tWindowTitle:="Problems with Job Form "+String:C10([Job_Forms:42]JobFormID:5)
$xlWinRef:=Open form window:C675([Job_Forms:42]; "P&GMaxMinFix"; Sheet form window:K39:12)  // Modified by: Mark Zinke (5/29/13)
SET WINDOW TITLE:C213(tWindowTitle; $xlWinRef)
DIALOG:C40([Job_Forms:42]; "P&GMaxMinFix")
CLOSE WINDOW:C154

Est_PandGBlob("Clear")  //Either way clear the contents of the blob so it can be refilled if needed.

If (Not:C34([Job_Forms:42]PandGProbsCkByMgr:84))  //Don't send email if manager has already checked the probs.
	If (bCancel#1)  // Added by: Mark Zinke (5/29/13)
		Est_PandGSendEmailEst(bOverride=1)
	End if 
End if 