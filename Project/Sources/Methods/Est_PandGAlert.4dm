//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 05/17/13, 15:22:27
// ----------------------------------------------------
// Method: Est_PandGAlert
// Description:
// Alerts the user to a problem with max/min quantities.
// ----------------------------------------------------

C_TEXT:C284(tWindowTitle)
C_LONGINT:C283($xlWinRef)

tWindowTitle:="Problems with Job Form "+String:C10([Job_Forms:42]JobFormID:5)
$xlWinRef:=Open form window:C675([Job_Forms:42]; "P&GMaxMinAlert"; Sheet form window:K39:12)  // Modified by: Mark Zinke (5/29/13)
SET WINDOW TITLE:C213(tWindowTitle; $xlWinRef)
DIALOG:C40([Job_Forms:42]; "P&GMaxMinAlert")
CLOSE WINDOW:C154