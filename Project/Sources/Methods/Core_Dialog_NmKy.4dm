//%attributes = {}
//  Method:  Core_Dialog_NmKy()
//  Description:  Displays a dialog to enter field Names and field keys and their values
//    Will search the database on these values

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	
	C_OBJECT:C1216($oWindow)
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Core_NmKy"
	$oWindow.nWindowType:=Plain form window:K39:10
	$oWindow.tTitle:="Core Name Key"
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Core_NmKy")

CLOSE WINDOW:C154($nWindowReference)
