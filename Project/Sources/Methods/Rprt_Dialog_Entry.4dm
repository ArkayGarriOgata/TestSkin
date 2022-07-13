//%attributes = {}
//Method:  Rprt_Dialog_Entry(tReport_Key)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tReport_Key)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nWindowReference)
	
	C_TEXT:C284($tWindowTitle)
	
	C_OBJECT:C1216($oOption)
	C_OBJECT:C1216($oWindow)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tReport_Key:=CorektBlank
	
	If ($nNumberOfParameters>=1)
		$tReport_Key:=$1
	End if 
	
	$oOption:=New object:C1471()
	$oWindow:=New object:C1471()
	
	Rprt_Entry_Initialize(CorektPhasePreDialog; ->$oOption; ->$tReport_Key)
	
	$oWindow.tFormName:="Rprt_Entry"
	$oWindow.nWindowType:=Sheet window:K34:15
	
	$nWindowReference:=0
	$tWindowTitle:="Report Entry"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

SET WINDOW TITLE:C213($tWindowTitle; $nWindowReference)

DIALOG:C40("Rprt_Entry"; $oOption)

CLOSE WINDOW:C154
