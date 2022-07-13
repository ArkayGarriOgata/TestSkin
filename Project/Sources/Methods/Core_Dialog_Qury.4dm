//%attributes = {}
//  Method:  Core_Dialog_Qury({oQuryDefined})
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
	$oWindow.tFormName:="Core_Qury"
	$oWindow.nHeight:=71
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Core_Qury"; $oQuryDefined)

CLOSE WINDOW:C154($nWindowReference)
