//%attributes = {}
//Method:  Arcv_Dialog_View
//Description:  This method allows a user to query and export of move records back

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	C_TEXT:C284($tWindowTitle)
	
	C_OBJECT:C1216($oWindow)
	C_LONGINT:C283($nWindowReference)
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="Arcv_View"
	$oWindow.nWindowType:=Plain form window:K39:10
	$oWindow.tTitle:="Archive View"
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
	$nWindowReference:=0
	$tWindowTitle:=""
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Arcv_View")

CLOSE WINDOW:C154
