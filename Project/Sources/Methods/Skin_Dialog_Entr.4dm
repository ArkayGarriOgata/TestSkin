//%attributes = {}
//  Method:  Skin_Dialog_Entr()
//  Description:  Displays a dialog to Entr family icons

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	C_OBJECT:C1216($oWindow)
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Skin_Entr"
	$oWindow.nWindowType:=Plain form window:K39:10
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40($oWindow.tFormName)

CLOSE WINDOW:C154($nWindowReference)
