//%attributes = {}
//Method:  Rprt_Dialog_Demo
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_LONGINT:C283($nWindowReference)
	
	C_OBJECT:C1216($oWindow)
	
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="Rprt_Demo"
	$oWindow.nWindowType:=Sheet window:K34:15
	
	$nWindowReference:=0
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Rprt_Demo")

CLOSE WINDOW:C154
