//%attributes = {}
//Method: RmTr_Dialog_Foil(eRawMatlTrns)
If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $eRawMatlTrns)
	
	C_OBJECT:C1216($oWindow)
	C_LONGINT:C283($nWindowReference)
	
	$eRawMatlTrns:=$1
	
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="RmTr_Foil"
	$oWindow.tTitle:="Modify Cold Foil"
	
End if   //Done initializing

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("RmTr_Foil"; $eRawMatlTrns)

CLOSE WINDOW:C154($nWindowReference)
