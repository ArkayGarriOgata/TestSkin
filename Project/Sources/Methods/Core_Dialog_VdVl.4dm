//%attributes = {}
//  Method:  Core_Dialog_VdVl()
//  Description:  Displays a dialog to Valid Values

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	
	C_OBJECT:C1216($oWindow)
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Core_VdVl"
	$oWindow.nWindowType:=Plain form window:K39:10
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Core_VdVl")

CLOSE WINDOW:C154($nWindowReference)
