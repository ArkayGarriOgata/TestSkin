//%attributes = {}
//Method:  UsSp_Menu_Entry
//Description:  This method allows a user to send an email to aMsHelp

If (True:C214)  //Initialize
	
	C_LONGINT:C283($nWindowReference)
	C_TEXT:C284($tWindowTitle)
	
	C_OBJECT:C1216($oWindow)
	C_LONGINT:C283($nWindowReference)
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="UsSp_Entry"
	$oWindow.nWindowType:=Sheet window:K34:15
	
	$nWindowReference:=0
	$tWindowTitle:="User Support for aMs Help"
	
	UsSp_Entry_Initialize(CorektPhasePreDialog)
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

SET WINDOW TITLE:C213($tWindowTitle; $nWindowReference)

DIALOG:C40("UsSp_Entry")

CLOSE WINDOW:C154
