//%attributes = {}
//  Method:  WbAr_Dialog_Video(oVideo)
//  Description:  Displays a dialog that will play a video that is passed in

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oVideo)
	
	C_LONGINT:C283($nWindowReference)
	
	C_OBJECT:C1216($oWindow)
	
	$oVideo:=$1
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="WbAr_Video"
	$oWindow.nWindowType:=Plain form window:K39:10
	$oWindow.tTitle:="Video Player"
	$oWindow.tCloseWindow:="Core_Window_CloseBox"
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("WbAr_Video"; $oVideo)

CLOSE WINDOW:C154($nWindowReference)