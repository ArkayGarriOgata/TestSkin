//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/17/13, 14:54:51
// ----------------------------------------------------
// Method: Est_PandGSendEmailTest
// ----------------------------------------------------

C_BOOLEAN:C305($0)

tWindowTitle:="Problems with Job Form "+String:C10([Job_Forms:42]JobFormID:5)
$xlWinRef:=Open form window:C675([Job_Forms:42]; "P&GMaxMinDialog"; Sheet form window:K39:12)  // Modified by: Mark Zinke (5/29/13)
SET WINDOW TITLE:C213(tWindowTitle; $xlWinRef)
DIALOG:C40([Job_Forms:42]; "P&GMaxMinDialog")
CLOSE WINDOW:C154

If (bSend=1)
	$0:=True:C214
Else 
	$0:=False:C215
End if 