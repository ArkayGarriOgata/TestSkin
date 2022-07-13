//%attributes = {}
//  Method:  Arky_Dialog_Prcs()
//  Description:  Displays a dialog of process story boards

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	
	C_OBJECT:C1216($oWindow)
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Arky_Prcs"
	$oWindow.nWindowType:=Plain window:K34:13
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Arky_Prcs")

CLOSE WINDOW:C154($nWindowReference)
