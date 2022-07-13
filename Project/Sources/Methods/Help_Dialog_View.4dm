//%attributes = {}
//  Method:  Help_Dialog_View(oView)
//  Description:  Displays a dialog to view Help URLs

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oView)
	
	C_LONGINT:C283($nWindowReference)
	
	C_OBJECT:C1216($oWindow)
	
	$oView:=New object:C1471()
	$oView:=$1
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Help_View"
	$oWindow.nWindowType:=Plain form window:K39:10
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40($oWindow.tFormName; $oView)

CLOSE WINDOW:C154($nWindowReference)