//%attributes = {}
//Method:  Quik_Menu_List
//Description:  This method allows a user to use canned quick reports

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	C_TEXT:C284($tWindowTitle)
	
	C_OBJECT:C1216($oWindow)
	C_LONGINT:C283($nWindowReference)
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="Quik_List"
	$oWindow.nWindowType:=Controller form window:K39:17
	
	$nWindowReference:=0
	$tWindowTitle:="Quick Query and Report"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

SET WINDOW TITLE:C213($tWindowTitle; $nWindowReference)

DIALOG:C40("Quik_List")

CLOSE WINDOW:C154
