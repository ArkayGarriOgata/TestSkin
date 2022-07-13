//%attributes = {}
//  Method:  Cust_Dialog_Color({oColorDefined})
//  Description:  Displays a Color editor

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oColorDefined)
	
	C_OBJECT:C1216($oWindow)
	C_LONGINT:C283($nNumberOfParameters; $nWindowReference)
	
	$oColorDefined:=New object:C1471()
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=1)
		
		$oColorDefined:=$1
		
	End if 
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Cust_Color"
	$oWindow.nHeight:=71
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Cust_Color"; $oColorDefined)

CLOSE WINDOW:C154($nWindowReference)
