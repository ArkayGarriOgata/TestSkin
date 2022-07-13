//%attributes = {}
//  Method:  Help_Dialog_Entr({oEntr})
//  Description:  Displays a dialog to enter help URL's

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oEntr)
	
	C_LONGINT:C283($nWindowReference)
	C_OBJECT:C1216($oWindow)
	
	If (Count parameters:C259>=1)  // Parameters
		$oEntr:=New object:C1471()
		$oEntr:=$1
	End if   // Done parameters
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Help_Entr"
	$oWindow.nWindowType:=Plain form window:K39:10
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

If (OB Is defined:C1231($oEntr))  // Dialog 
	
	DIALOG:C40($oWindow.tFormName; $oEntr; *)
	
Else 
	
	DIALOG:C40("Help_Entr")
	
	CLOSE WINDOW:C154($nWindowReference)
	
End if   // Done dialog
