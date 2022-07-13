//%attributes = {}
//  Method:  Qury_Dialog_View({oQuryDefined})
//  Description:  Displays a qury editor

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oQuryDefined)
	
	C_OBJECT:C1216($oWindow)
	C_LONGINT:C283($nNumberOfParameters; $nWindowReference)
	
	$oQuryDefined:=New object:C1471()
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=1)
		
		$oQuryDefined:=$1
		
	End if 
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Qury_View"
	$oWindow.nHeight:=71
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Qury_View"; $oQuryDefined)

CLOSE WINDOW:C154($nWindowReference)
