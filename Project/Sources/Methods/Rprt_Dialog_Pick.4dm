//%attributes = {}
//  Method:  Rprt_Dialog_Pick()
//  Description:  Displays a dialog to Pick a report

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	
	C_OBJECT:C1216($oWindow)
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Rprt_Pick"
	$oWindow.nWindowType:=Plain form window:K39:10
	$oWindow.tTitle:="Reports for "+Current user:C182()
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)
SET MENU BAR:C67(<>DefaultMenu)

DIALOG:C40("Rprt_Pick")

CLOSE WINDOW:C154($nWindowReference)
