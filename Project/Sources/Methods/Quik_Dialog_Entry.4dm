//%attributes = {}
//Method:  Quik_Dialog_Entry(tQuick_Key)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tQuick_Key)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nWindowReference)
	
	C_TEXT:C284($tWindowTitle)
	
	C_OBJECT:C1216($oWindow)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tQuick_Key:=CorektBlank
	
	If ($nNumberOfParameters>=1)
		$tQuick_Key:=$1
	End if 
	
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="Quik_Entry"
	$oWindow.nWindowType:=Sheet window:K34:15
	
	$nWindowReference:=0
	$tWindowTitle:="Quick Report Entry"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

SET WINDOW TITLE:C213($tWindowTitle; $nWindowReference)

Quik_Entry_Initialize(CorektPhasePreDialog; ->$tQuick_Key)

DIALOG:C40("Quik_Entry")

CLOSE WINDOW:C154
