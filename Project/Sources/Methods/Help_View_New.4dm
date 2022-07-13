//%attributes = {}
// Method: Help_View_New
// description: this method will bring up an instance of Help Entr from view

If (True:C214)  // Initialize
	
	C_OBJECT:C1216($oView)
	
	$oView:=New object:C1471()
	$oView.viewProcess:=Current process:C322
	$oView.state:=Process state:C330($oView.viewProcess)
	$oview.frontProc:=Frontmost process:C327(*)
	
End if   // Done initiliaze

If (Current user:C182="Designer")  // Usergroup
	Help_Dialog_Entr($oView)
End if   // Done usergroup
