//%attributes = {}
//Method:  Quik_Dialog_List
//Description:  This method will run a saved query and a saved quick report

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oWindow)
	
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="Quik_List"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Quik_List")
